import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_formatter.dart';
import 'package:loantrack/core/router/app_router.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/core/widgets/loan_status_chip.dart';
import 'package:loantrack/core/widgets/reliability_indicator.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_reliability.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/domain/models/reliability_color.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_status.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/features/borrower_detail/borrower_detail_providers.dart';
import 'package:loantrack/features/borrower_detail/borrower_detail_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoanRepository extends Mock implements LoanRepository {}

void main() {
  const borrowerId = 1;
  late _MockLoanRepository loanRepository;

  setUp(() {
    loanRepository = _MockLoanRepository();
    when(() => loanRepository.delete(any())).thenAnswer((_) async {});
  });

  Future<void> pumpScreen(WidgetTester tester, BorrowerDetail? detail) async {
    final router = GoRouter(
      initialLocation: AppRoutes.borrowerDetail(borrowerId),
      routes: [
        GoRoute(
          path: AppRoutes.borrowerDetail(borrowerId),
          builder: (_, _) => const BorrowerDetailScreen(borrowerId: borrowerId),
        ),
        GoRoute(
          path: AppRoutes.newLoan(borrowerId),
          builder: (_, _) => const Text('ECR-04'),
        ),
        GoRoute(
          path: '${AppRoutes.borrowerDetail(borrowerId)}/loans/:loanId/edit',
          builder: (_, state) =>
              Text('ECR-04 edit ${state.pathParameters['loanId']}'),
        ),
        GoRoute(
          path: '${AppRoutes.borrowerDetail(borrowerId)}/loans/:loanId',
          builder: (_, state) =>
              Text('ECR-05 ${state.pathParameters['loanId']}'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          borrowerDetailProvider.overrideWith((ref, id) async => detail),
          loanRepositoryProvider.overrideWithValue(loanRepository),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          theme: AppTheme.light(null),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Formatted with non-breaking spaces: `1 000,000 TND`.
  String tnd(int amountMinor) =>
      MoneyFormatter.format(Money(amountMinor), Currency.tnd);

  final borrower = Borrower(
    id: borrowerId,
    name: 'Ali',
    phone: '20 000 000',
    note: 'Voisin',
    createdAt: LocalDay(2026, 9, 1),
  );

  LoanItem item(
    int id, {
    required int amount,
    int repaid = 0,
    required LocalDay loanDate,
    LocalDay? promised,
    required LoanStatus status,
  }) => (
    summary: LoanSummary(
      loan: Loan(
        id: id,
        borrowerId: borrowerId,
        amount: Money(amount),
        loanDate: loanDate,
        promisedReturnDate: promised,
      ),
      repaid: Money(repaid),
    ),
    status: status,
  );

  BorrowerDetail detail(
    List<LoanItem> loans, {
    BorrowerReliability reliability = BorrowerReliability.notEvaluated,
  }) => (
    summary: BorrowerSummary(
      borrower: borrower,
      totalLent: Money(
        loans.fold(0, (sum, l) => sum + l.summary.loan.amount.amountMinor),
      ),
      totalRepaid: Money(
        loans.fold(0, (sum, l) => sum + l.summary.repaid.amountMinor),
      ),
      loanCount: loans.length,
      activeLoanCount: 0,
      overdueLoanCount: 0,
      reliability: reliability,
    ),
    loans: loans,
  );

  group('reliability (US-7.2)', () {
    BorrowerReliability reliability(
      ReliabilityColor color, {
      int late = 0,
      int long = 0,
    }) => BorrowerReliability(
      evaluatedLoanCount: late + 1,
      lateLoanCount: late,
      longDelayCount: long,
      color: color,
    );

    for (final (color, late, long, label, detailText) in [
      (
        ReliabilityColor.blue,
        1,
        0,
        '1 retard court',
        "1 prêt en retard, dont aucun de plus d'un mois",
      ),
      (
        ReliabilityColor.orange,
        2,
        1,
        '2 retards dont 1 long',
        "2 prêts en retard, dont 1 de plus d'un mois",
      ),
      (
        ReliabilityColor.black,
        5,
        3,
        'Retards très fréquents',
        "5 prêts en retard, dont 3 de plus d'un mois",
      ),
    ]) {
      testWidgets('$color shows its label and N / L', (tester) async {
        await pumpScreen(
          tester,
          detail(
            const [],
            reliability: reliability(color, late: late, long: long),
          ),
        );

        expect(find.text('Fiabilité'), findsOneWidget);
        expect(find.byType(ReliabilityDot), findsOneWidget);
        expect(find.text(label), findsOneWidget);
        expect(find.text(detailText), findsOneWidget);
      });
    }

    for (final (color, label) in [
      (ReliabilityColor.green, "Toujours à l'heure"),
      (ReliabilityColor.notEvaluated, 'Non évalué'),
    ]) {
      testWidgets('$color shows its label without N / L', (tester) async {
        await pumpScreen(
          tester,
          detail(const [], reliability: reliability(color)),
        );

        expect(find.text(label), findsOneWidget);
        expect(find.textContaining('en retard, dont'), findsNothing);
      });
    }
  });

  testWidgets('shows contact, totals and the empty loans state', (
    tester,
  ) async {
    await pumpScreen(tester, detail(const []));

    expect(find.text('Ali'), findsOneWidget);
    expect(find.text('20 000 000'), findsOneWidget);
    expect(find.text('Voisin'), findsOneWidget);
    expect(find.text('Total prêté'), findsOneWidget);
    expect(find.text('Total remboursé'), findsOneWidget);
    expect(find.text('Reste dû'), findsOneWidget);
    expect(
      find.text('Aucun prêt. Appuyez sur « Prêt » pour en ajouter un.'),
      findsOneWidget,
    );
    expect(find.byType(LoanStatusChip), findsNothing);
  });

  testWidgets('shows one card per loan with dates, amounts and status', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      detail([
        item(
          2,
          amount: 1000000,
          repaid: 250000,
          loanDate: LocalDay(2026, 10, 1),
          promised: LocalDay(2026, 10, 25),
          status: const LoanStatus.overdue(days: 10),
        ),
        item(
          1,
          amount: 500000,
          repaid: 500000,
          loanDate: LocalDay(2026, 9, 1),
          status: LoanStatus.repaid(repaidOn: LocalDay(2026, 9, 20)),
        ),
      ]),
    );

    // Totals: 1 500 lent, 750 repaid, 750 remaining.
    expect(find.text(tnd(1500000)), findsOneWidget);
    expect(find.text(tnd(750000)), findsNWidgets(2));

    expect(find.text(tnd(1000000)), findsOneWidget);
    expect(find.text('Prêté le 01/10/2026'), findsOneWidget);
    expect(find.text('Retour promis : 25/10/2026'), findsOneWidget);
    expect(find.text('Remboursé : ${tnd(250000)}'), findsOneWidget);
    expect(find.text('Reste dû : ${tnd(750000)}'), findsOneWidget);
    expect(find.text('En retard de 10 jours'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Remboursé le 20/09/2026'), 100);
    expect(find.text('Prêté le 01/09/2026'), findsOneWidget);
    expect(find.text('Retour promis : Non définie'), findsOneWidget);
    expect(find.text('Remboursé'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
  });

  testWidgets('shows each status label', (tester) async {
    final day = LocalDay(2026, 10, 1);
    await pumpScreen(
      tester,
      detail([
        item(
          3,
          amount: 1000,
          loanDate: day,
          status: const LoanStatus.ongoing(),
        ),
        item(
          2,
          amount: 1000,
          repaid: 500,
          loanDate: day,
          status: const LoanStatus.partiallyRepaid(),
        ),
        item(
          1,
          amount: 1000,
          loanDate: day,
          status: const LoanStatus.overdue(days: 1),
        ),
      ]),
    );

    expect(find.text('En cours'), findsOneWidget);
    expect(find.text('Partiellement remboursé'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('En retard de 1 jour'), 100);
    expect(find.text('En retard de 1 jour'), findsOneWidget);
  });

  testWidgets('"+ Prêt" opens the loan form (ECR-04)', (tester) async {
    await pumpScreen(tester, detail(const []));

    await tester.tap(find.text('Prêt'));
    await tester.pumpAndSettle();

    expect(find.text('ECR-04'), findsOneWidget);
  });

  testWidgets('menu offers edit and delete', (tester) async {
    await pumpScreen(tester, detail(const []));

    await tester.tap(find.byTooltip("Plus d'actions"));
    await tester.pumpAndSettle();

    expect(find.text("Modifier l'emprunteur"), findsOneWidget);
    expect(find.text('Supprimer'), findsOneWidget);
  });

  group('loan menu (US-2.4)', () {
    final loans = [
      item(
        4,
        amount: 1000000,
        loanDate: LocalDay(2026, 10, 1),
        status: const LoanStatus.ongoing(),
      ),
    ];

    // The loan menu is the one inside the loan card (the borrower menu is in
    // the app bar).
    Future<void> openLoanMenu(WidgetTester tester) async {
      await tester.tap(
        find.descendant(
          of: find.ancestor(
            of: find.byType(LoanStatusChip),
            matching: find.byType(Card),
          ),
          matching: find.byTooltip("Plus d'actions"),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('tapping a loan card opens the loan detail (ECR-05)', (
      tester,
    ) async {
      await pumpScreen(tester, detail(loans));

      await tester.tap(find.text('Prêté le 01/10/2026'));
      await tester.pumpAndSettle();

      expect(find.text('ECR-05 4'), findsOneWidget);
    });

    testWidgets('"Modifier le prêt" opens the loan form (ECR-04)', (
      tester,
    ) async {
      await pumpScreen(tester, detail(loans));
      await openLoanMenu(tester);

      await tester.tap(find.text('Modifier le prêt'));
      await tester.pumpAndSettle();

      expect(find.text('ECR-04 edit 4'), findsOneWidget);
    });

    testWidgets('"Supprimer le prêt" asks for confirmation (RG-14)', (
      tester,
    ) async {
      await pumpScreen(tester, detail(loans));
      await openLoanMenu(tester);
      await tester.tap(find.text('Supprimer le prêt'));
      await tester.pumpAndSettle();

      expect(find.text('Supprimer ce prêt ?'), findsOneWidget);
      expect(
        find.text(
          'Le prêt de ${tnd(1000000)} du 01/10/2026 et tous ses '
          'remboursements seront supprimés.',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();
      verifyNever(() => loanRepository.delete(any()));

      await openLoanMenu(tester);
      await tester.tap(find.text('Supprimer le prêt'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Supprimer'));
      await tester.pumpAndSettle();

      verify(() => loanRepository.delete(4)).called(1);
    });

    testWidgets('"Ajouter un remboursement" opens ECR-05b (US-3.1)', (
      tester,
    ) async {
      await pumpScreen(tester, detail(loans));
      await openLoanMenu(tester);

      await tester.tap(find.text('Ajouter un remboursement'));
      await tester.pumpAndSettle();

      expect(find.text('Nouveau remboursement'), findsOneWidget);
      expect(find.text('Reste dû : ${tnd(1000000)}'), findsNWidgets(2));
    });

    testWidgets('a repaid loan offers no repayment', (tester) async {
      await pumpScreen(
        tester,
        detail([
          item(
            4,
            amount: 1000000,
            repaid: 1000000,
            loanDate: LocalDay(2026, 10, 1),
            status: LoanStatus.repaid(repaidOn: LocalDay(2026, 10, 20)),
          ),
        ]),
      );
      await openLoanMenu(tester);

      expect(find.text('Ajouter un remboursement'), findsNothing);
      expect(find.text('Modifier le prêt'), findsOneWidget);
    });
  });

  testWidgets('shows a message when the borrower does not exist', (
    tester,
  ) async {
    await pumpScreen(tester, null);

    expect(find.text("Cet emprunteur n'existe plus."), findsOneWidget);
    expect(find.text('Prêt'), findsNothing);
  });
}
