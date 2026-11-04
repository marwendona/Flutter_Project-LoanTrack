import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_formatter.dart';
import 'package:loantrack/core/router/app_router.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_status.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/domain/models/repayment.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/features/loan_detail/loan_detail_providers.dart';
import 'package:loantrack/features/loan_detail/loan_detail_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoanRepository extends Mock implements LoanRepository {}

void main() {
  const borrowerId = 1;
  const loanId = 4;
  late _MockLoanRepository loanRepository;

  setUp(() {
    loanRepository = _MockLoanRepository();
    when(() => loanRepository.delete(any())).thenAnswer((_) async {});
  });

  Future<void> pumpScreen(WidgetTester tester, LoanDetail? detail) async {
    final router = GoRouter(
      initialLocation: AppRoutes.borrowerDetail(borrowerId),
      routes: [
        GoRoute(
          path: AppRoutes.borrowerDetail(borrowerId),
          builder: (_, _) => const Text('ECR-03'),
          routes: [
            GoRoute(
              path: 'loans/:loanId',
              builder: (_, _) => const LoanDetailScreen(
                borrowerId: borrowerId,
                loanId: loanId,
              ),
            ),
            GoRoute(
              path: 'loans/:loanId/edit',
              builder: (_, state) =>
                  Text('ECR-04 edit ${state.pathParameters['loanId']}'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loanDetailProvider.overrideWith((ref, id) async => detail),
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
    // Pushed above ECR-03 so that "back" after a deletion can be checked.
    unawaited(router.push(AppRoutes.loanDetail(borrowerId, loanId)));
    await tester.pumpAndSettle();
  }

  // Formatted with non-breaking spaces: `1 000,000 TND`.
  String tnd(int amountMinor) =>
      MoneyFormatter.format(Money(amountMinor), Currency.tnd);

  LoanDetail detail({
    int repaid = 0,
    required LoanStatus status,
    List<Repayment> repayments = const [],
    String? note,
  }) => (
    summary: LoanSummary(
      loan: Loan(
        id: loanId,
        borrowerId: borrowerId,
        amount: const Money(1000000),
        loanDate: LocalDay(2026, 10, 1),
        promisedReturnDate: LocalDay(2026, 10, 25),
        note: note,
      ),
      repaid: Money(repaid),
    ),
    status: status,
    repayments: repayments,
  );

  Repayment repayment(int id, int amount, LocalDay date, {String? note}) =>
      Repayment(
        id: id,
        loanId: loanId,
        amount: Money(amount),
        repaymentDate: date,
        note: note,
      );

  testWidgets('shows the loan and its repayments in the given order', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      detail(
        repaid: 400000,
        status: const LoanStatus.overdue(days: 10),
        note: 'voiture',
        repayments: [
          repayment(2, 300000, LocalDay(2026, 10, 20), note: 'espèces'),
          repayment(1, 100000, LocalDay(2026, 10, 5)),
        ],
      ),
    );

    expect(find.text('Détail du prêt'), findsOneWidget);
    expect(find.text(tnd(1000000)), findsOneWidget);
    expect(find.text('En retard de 10 jours'), findsOneWidget);
    expect(find.text('Prêté le 01/10/2026'), findsOneWidget);
    expect(find.text('Retour promis : 25/10/2026'), findsOneWidget);
    expect(find.text('voiture'), findsOneWidget);
    expect(find.text('Remboursé : ${tnd(400000)}'), findsOneWidget);
    expect(find.text('Reste dû : ${tnd(600000)}'), findsOneWidget);

    expect(find.text('Remboursements'), findsOneWidget);
    expect(find.text(tnd(300000)), findsOneWidget);
    expect(find.text('espèces'), findsOneWidget);
    expect(find.text(tnd(100000)), findsOneWidget);
    // Most recent first, as provided by the repository.
    final recent = tester.getTopLeft(find.text('20/10/2026')).dy;
    final older = tester.getTopLeft(find.text('05/10/2026')).dy;
    expect(recent, lessThan(older));
  });

  testWidgets('shows the empty history', (tester) async {
    await pumpScreen(tester, detail(status: const LoanStatus.ongoing()));

    expect(find.text('Aucun remboursement.'), findsOneWidget);
  });

  testWidgets('"+ Remboursement" opens ECR-05b', (tester) async {
    await pumpScreen(tester, detail(status: const LoanStatus.ongoing()));

    await tester.tap(find.text('Remboursement'));
    await tester.pumpAndSettle();

    expect(find.text('Nouveau remboursement'), findsOneWidget);
  });

  testWidgets('a tap on a repayment opens ECR-05b in edition (US-3.3)', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      detail(
        repaid: 1000000,
        status: LoanStatus.repaid(repaidOn: LocalDay(2026, 10, 20)),
        repayments: [repayment(1, 1000000, LocalDay(2026, 10, 20))],
      ),
    );

    await tester.tap(find.text('20/10/2026'));
    await tester.pumpAndSettle();

    expect(find.text('Modifier le remboursement'), findsOneWidget);
    // Fully repaid loan: the maximum is the initial amount itself (RG-16).
    expect(find.text('Montant maximal : ${tnd(1000000)}'), findsOneWidget);
    expect(find.text('Supprimer'), findsOneWidget);
  });

  testWidgets('"+ Remboursement" is hidden once the loan is repaid', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      detail(
        repaid: 1000000,
        status: LoanStatus.repaid(repaidOn: LocalDay(2026, 10, 20)),
        repayments: [repayment(1, 1000000, LocalDay(2026, 10, 20))],
      ),
    );

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('Remboursé le 20/10/2026'), findsOneWidget);
  });

  testWidgets('"Modifier le prêt" opens ECR-04', (tester) async {
    await pumpScreen(tester, detail(status: const LoanStatus.ongoing()));

    await tester.tap(find.byTooltip("Plus d'actions"));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Modifier le prêt'));
    await tester.pumpAndSettle();

    expect(find.text('ECR-04 edit $loanId'), findsOneWidget);
  });

  testWidgets('"Supprimer le prêt" deletes after confirmation and goes back', (
    tester,
  ) async {
    await pumpScreen(tester, detail(status: const LoanStatus.ongoing()));

    await tester.tap(find.byTooltip("Plus d'actions"));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supprimer le prêt'));
    await tester.pumpAndSettle();
    expect(find.text('Supprimer ce prêt ?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Supprimer'));
    await tester.pumpAndSettle();

    verify(() => loanRepository.delete(loanId)).called(1);
    expect(find.text('ECR-03'), findsOneWidget);
  });

  testWidgets('shows a message when the loan does not exist', (tester) async {
    await pumpScreen(tester, null);

    expect(find.text("Ce prêt n'existe plus."), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}
