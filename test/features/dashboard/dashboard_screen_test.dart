import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_formatter.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/core/theme/status_colors.dart';
import 'package:loantrack/domain/models/global_totals.dart';
import 'package:loantrack/features/borrowers/borrower_form_sheet.dart';
import 'package:loantrack/features/dashboard/dashboard_providers.dart';
import 'package:loantrack/features/dashboard/dashboard_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester,
    GlobalTotals totals, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          globalTotalsProvider.overrideWith((ref) => Stream.value(totals)),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          theme: theme ?? AppTheme.light(null),
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

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
    expect(find.text('100 %'), findsOneWidget);
  });
}
