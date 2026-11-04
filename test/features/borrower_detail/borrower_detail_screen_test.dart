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
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_status.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/features/borrower_detail/borrower_detail_providers.dart';
import 'package:loantrack/features/borrower_detail/borrower_detail_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  const borrowerId = 1;

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
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          borrowerDetailProvider.overrideWith((ref, id) async => detail),
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

  BorrowerDetail detail(List<LoanItem> loans) => (
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
    ),
    loans: loans,
  );

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

  testWidgets('shows a message when the borrower does not exist', (
    tester,
  ) async {
    await pumpScreen(tester, null);

    expect(find.text("Cet emprunteur n'existe plus."), findsOneWidget);
    expect(find.text('Prêt'), findsNothing);
  });
}
