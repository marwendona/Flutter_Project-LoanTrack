import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_formatter.dart';
import 'package:loantrack/core/router/app_router.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/core/widgets/reliability_indicator.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_reliability.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/domain/models/reliability_color.dart';
import 'package:loantrack/features/borrowers/borrowers_providers.dart';
import 'package:loantrack/features/borrowers/borrowers_screen.dart';
import 'package:loantrack/features/borrowers_by_color/borrowers_by_color_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  // Same nesting as the app: ECR-07 and ECR-03 under ECR-02.
  Future<GoRouter> pumpApp(
    WidgetTester tester,
    List<BorrowerSummary> summaries, {
    String initialLocation = AppRoutes.borrowersByColor,
  }) async {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.borrowers,
          builder: (_, _) => const BorrowersScreen(),
          routes: [
            GoRoute(
              path: 'by-color',
              builder: (_, _) => const BorrowersByColorScreen(),
            ),
            GoRoute(
              path: ':borrowerId',
              builder: (_, state) =>
                  Text('ECR-03 ${state.pathParameters['borrowerId']}'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
          theme: AppTheme.light(null),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  String tnd(int amountMinor) =>
      MoneyFormatter.format(Money(amountMinor), Currency.tnd);

  BorrowerSummary summary(
    int id,
    String name,
    ReliabilityColor color, {
    int remaining = 0,
    int late = 0,
    int long = 0,
  }) => BorrowerSummary(
    borrower: Borrower(id: id, name: name, createdAt: LocalDay(2026, 10, 1)),
    totalLent: Money(remaining),
    totalRepaid: Money.zero,
    loanCount: 1,
    activeLoanCount: 1,
    overdueLoanCount: 0,
    reliability: BorrowerReliability(
      evaluatedLoanCount: late,
      lateLoanCount: late,
      longDelayCount: long,
      color: color,
    ),
  );

  final summaries = [
    summary(1, 'Ali', ReliabilityColor.notEvaluated, remaining: 9000),
    summary(
      2,
      'Mona',
      ReliabilityColor.orange,
      remaining: 1000,
      late: 2,
      long: 1,
    ),
    summary(3, 'Sami', ReliabilityColor.green, remaining: 3000),
    summary(
      4,
      'Zied',
      ReliabilityColor.orange,
      remaining: 5000,
      late: 2,
      long: 1,
    ),
    summary(5, 'Hela', ReliabilityColor.blue, late: 1),
  ];

  /// Section labels and borrower names, top to bottom.
  List<String> visibleOrder(WidgetTester tester) {
    final texts = find.byWidgetPredicate(
      (w) =>
          w is Text &&
          const {
            "Toujours à l'heure",
            '1 retard court',
            '2 retards dont 1 long',
            'Non évalué',
            'Ali',
            'Mona',
            'Sami',
            'Zied',
            'Hela',
          }.contains(w.data),
    );
    final entries = [
      for (final element in texts.evaluate())
        (
          (element.widget as Text).data!,
          tester.getTopLeft(find.byWidget(element.widget)).dy,
        ),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
    return [for (final e in entries) e.$1];
  }

  testWidgets('shows the empty state', (tester) async {
    await pumpApp(tester, const []);

    expect(find.text('Emprunteurs par couleur'), findsOneWidget);
    expect(find.text('Aucun emprunteur.'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('groups the borrowers by color, sections in RG-64 order and '
      'RG-04 inside each section', (tester) async {
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpApp(tester, summaries);

    expect(visibleOrder(tester), [
      "Toujours à l'heure",
      'Sami',
      '1 retard court',
      'Hela',
      '2 retards dont 1 long',
      'Zied',
      'Mona',
      'Non évalué',
      'Ali',
    ]);
    // Empty colors are not shown.
    for (final label in [
      '1 retard long',
      '2 retards courts',
      'Retards fréquents',
      'Retards très fréquents',
    ]) {
      expect(find.text(label), findsNothing);
    }
    // Headers: dot, label and borrower count.
    expect(find.byType(ReliabilityDot), findsNWidgets(4));
    expect(find.text('2 emprunteurs'), findsOneWidget);
    expect(find.text('1 emprunteur'), findsNWidgets(3));
  });

  testWidgets('a row shows the name, the remaining due, N and L', (
    tester,
  ) async {
    await pumpApp(tester, summaries);

    final zied = find.ancestor(
      of: find.text('Zied'),
      matching: find.byType(ListTile),
    );
    expect(find.descendant(of: zied, matching: find.text(tnd(5000))), findsOne);
    expect(
      find.descendant(
        of: zied,
        matching: find.text("2 prêts en retard, dont 1 de plus d'un mois"),
      ),
      findsOne,
    );

    final hela = find.ancestor(
      of: find.text('Hela'),
      matching: find.byType(ListTile),
    );
    expect(
      find.descendant(
        of: hela,
        matching: find.text("1 prêt en retard, dont aucun de plus d'un mois"),
      ),
      findsOne,
    );

    final sami = find.ancestor(
      of: find.text('Sami'),
      matching: find.byType(ListTile),
    );
    expect(
      find.descendant(of: sami, matching: find.text('Aucun prêt en retard')),
      findsOne,
    );
  });

  testWidgets('tapping a row opens ECR-03, back returns to ECR-07', (
    tester,
  ) async {
    final router = await pumpApp(tester, summaries);

    await tester.tap(find.text('Sami'));
    await tester.pumpAndSettle();
    expect(find.text('ECR-03 3'), findsOneWidget);

    // System back: the ECR-03 stand-in has no app bar.
    expect(router.canPop(), isTrue);
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Emprunteurs par couleur'), findsOneWidget);
  });

  testWidgets('the legend dialog explains every color (RG-62)', (tester) async {
    await pumpApp(tester, const []);

    await tester.tap(find.byTooltip('Signification des couleurs'));
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    expect(
      find.descendant(of: dialog, matching: find.byType(ReliabilityDot)),
      findsNWidgets(ReliabilityColor.values.length),
    );
    for (final text in [
      "Toujours à l'heure",
      'Un seul prêt en retard, de plus d\'un mois.',
      'Retards fréquents',
      'Deux prêts en retard de plus d\'un mois, ou trois prêts en retard.',
      'Plus de trois prêts en retard.',
      'Non évalué',
    ]) {
      expect(find.descendant(of: dialog, matching: find.text(text)), findsOne);
    }

    await tester.tap(find.text('Fermer'));
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);
  });

  testWidgets('the ECR-02 button opens ECR-07, back returns to ECR-02', (
    tester,
  ) async {
    await pumpApp(tester, summaries, initialLocation: AppRoutes.borrowers);

    await tester.tap(find.byTooltip('Emprunteurs par couleur'));
    await tester.pumpAndSettle();
    expect(find.byType(BorrowersByColorScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Retour'));
    await tester.pumpAndSettle();
    expect(find.byType(BorrowersByColorScreen), findsNothing);
    expect(find.byType(BorrowersScreen), findsOneWidget);
  });
}
