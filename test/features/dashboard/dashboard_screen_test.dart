import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_formatter.dart';
import 'package:loantrack/core/router/app_router.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/core/theme/status_colors.dart';
import 'package:loantrack/core/widgets/overdue_badge.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/domain/models/global_totals.dart';
import 'package:loantrack/features/borrowers/borrower_form_sheet.dart';
import 'package:loantrack/features/borrowers/borrowers_providers.dart';
import 'package:loantrack/features/dashboard/dashboard_providers.dart';
import 'package:loantrack/features/dashboard/dashboard_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester,
    GlobalTotals totals, {
    List<BorrowerSummary> summaries = const [],
    ThemeData? theme,
  }) async {
    final router = GoRouter(
      initialLocation: AppRoutes.dashboard,
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (_, _) => const DashboardScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.borrowers}/:borrowerId',
          builder: (_, state) =>
              Text('ECR-03 ${state.pathParameters['borrowerId']}'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          globalTotalsProvider.overrideWith((ref) => Stream.value(totals)),
          borrowerSummariesProvider.overrideWith(
            (ref) => Stream.value(summaries),
          ),
        ],
        child: MaterialApp.router(
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          theme: theme ?? AppTheme.light(null),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  BorrowerSummary summary({
    required int id,
    required String name,
    required int lent,
    int repaid = 0,
    int overdue = 0,
  }) => BorrowerSummary(
    borrower: Borrower(id: id, name: name, createdAt: LocalDay(2026, 10, 1)),
    totalLent: Money(lent),
    totalRepaid: Money(repaid),
    loanCount: 1,
    activeLoanCount: lent > repaid ? 1 : 0,
    overdueLoanCount: overdue,
  );

  String tnd(int amountMinor) =>
      MoneyFormatter.format(Money(amountMinor), Currency.tnd);

  GlobalTotals totals({
    int lent = 3800000,
    int repaid = 1050000,
    int borrowersWithRemaining = 2,
    int overdueCount = 0,
    int overdueAmount = 0,
  }) => GlobalTotals(
    totalLent: Money(lent),
    totalRepaid: Money(repaid),
    loanCount: 4,
    borrowersWithRemainingCount: borrowersWithRemaining,
    overdueLoanCount: overdueCount,
    overdueAmount: Money(overdueAmount),
  );

  Color? textColor(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style?.color;

  testWidgets('shows the empty state without any loan', (tester) async {
    await pumpScreen(tester, GlobalTotals.empty);

    expect(find.text('Aucun prêt enregistré'), findsOneWidget);
    expect(find.text('Reste à recevoir'), findsNothing);

    await tester.tap(find.text('Ajouter un emprunteur'));
    await tester.pumpAndSettle();
    expect(find.byType(BorrowerFormSheet), findsOneWidget);
  });

  testWidgets('shows remaining, totals and repayment rate (RG-31, RG-32)', (
    tester,
  ) async {
    await pumpScreen(tester, totals());

    expect(find.text('Reste à recevoir'), findsOneWidget);
    expect(find.text(tnd(2750000)), findsOneWidget);
    expect(find.text('Auprès de 2 emprunteurs'), findsOneWidget);
    expect(find.text('Total prêté'), findsOneWidget);
    expect(find.text(tnd(3800000)), findsOneWidget);
    expect(find.text('Total remboursé'), findsOneWidget);
    expect(find.text(tnd(1050000)), findsOneWidget);
    expect(find.text('Taux de remboursement'), findsOneWidget);
    expect(find.text('27 %'), findsOneWidget);
    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, closeTo(1050000 / 3800000, 1e-9));
  });

  testWidgets('overdue loans are neutral when there are none', (tester) async {
    await pumpScreen(tester, totals());

    expect(find.text('Aucun prêt en retard'), findsOneWidget);
    expect(
      textColor(tester, 'Aucun prêt en retard'),
      isNot(StatusColors.light.overdue),
    );
  });

  testWidgets('overdue loans are shown in red when > 0 (RG-31)', (
    tester,
  ) async {
    await pumpScreen(tester, totals(overdueCount: 2, overdueAmount: 800000));

    expect(find.text('2 prêts en retard'), findsOneWidget);
    expect(find.text(tnd(800000)), findsOneWidget);
    expect(textColor(tester, '2 prêts en retard'), StatusColors.light.overdue);
    expect(textColor(tester, tnd(800000)), StatusColors.light.overdue);
  });

  testWidgets('uses the dark overdue color in dark mode', (tester) async {
    await pumpScreen(
      tester,
      totals(overdueCount: 1, overdueAmount: 100000),
      theme: AppTheme.dark(null),
    );

    expect(find.text('1 prêt en retard'), findsOneWidget);
    expect(textColor(tester, '1 prêt en retard'), StatusColors.dark.overdue);
  });

  testWidgets('fully repaid: 100 % and nobody owes money (RG-33)', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      totals(lent: 500000, repaid: 500000, borrowersWithRemaining: 0),
    );

    expect(find.text(tnd(0)), findsNWidgets(2)); // remaining + overdue amount
    expect(find.text("Aucun emprunteur ne vous doit d'argent"), findsOneWidget);
    expect(find.text('Par emprunteur'), findsNothing);
    expect(find.text('100 %'), findsOneWidget);
  });

  group('by borrower (US-4.2)', () {
    final summaries = [
      summary(id: 2, name: 'Sami', lent: 2000000, repaid: 500000, overdue: 1),
      summary(id: 1, name: 'Ali', lent: 1300000, repaid: 50000),
      summary(id: 3, name: 'Mona', lent: 500000, repaid: 500000),
    ];

    testWidgets('shows lent, repaid and remaining per borrower (RG-30)', (
      tester,
    ) async {
      await pumpScreen(tester, totals(), summaries: summaries);
      await tester.scrollUntilVisible(find.text('Mona'), 100);

      expect(find.text('Par emprunteur'), findsOneWidget);
      expect(find.text('Reste dû'), findsNWidgets(3));
      expect(find.text(tnd(1500000)), findsOneWidget); // Sami remaining
      expect(find.text(tnd(1300000)), findsOneWidget); // Ali lent
      expect(find.text(tnd(50000)), findsOneWidget); // Ali repaid
      expect(find.text(tnd(1250000)), findsOneWidget); // Ali remaining
      // Sami repaid + Mona lent + Mona repaid.
      expect(find.text(tnd(500000)), findsNWidgets(3));
    });

    testWidgets('keeps the order of the provider (RG-04)', (tester) async {
      await pumpScreen(tester, totals(), summaries: summaries);
      await tester.scrollUntilVisible(find.text('Mona'), 100);

      final sami = tester.getTopLeft(find.text('Sami')).dy;
      final ali = tester.getTopLeft(find.text('Ali')).dy;
      final mona = tester.getTopLeft(find.text('Mona')).dy;
      expect(sami, lessThan(ali));
      expect(ali, lessThan(mona));
    });

    testWidgets('shows the overdue badge only for overdue borrowers', (
      tester,
    ) async {
      await pumpScreen(tester, totals(), summaries: summaries);
      await tester.scrollUntilVisible(find.text('Mona'), 100);

      expect(find.byType(OverdueBadge), findsOneWidget);
      final badgeRow = find.ancestor(
        of: find.byType(OverdueBadge),
        matching: find.byType(Row),
      );
      expect(
        find.descendant(of: badgeRow.first, matching: find.text('Sami')),
        findsOneWidget,
      );
    });

    testWidgets('tap on a borrower opens its detail (ECR-03)', (tester) async {
      await pumpScreen(tester, totals(), summaries: summaries);
      await tester.ensureVisible(find.text('Ali'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ali'));
      await tester.pumpAndSettle();

      expect(find.text('ECR-03 1'), findsOneWidget);
    });
  });
}
