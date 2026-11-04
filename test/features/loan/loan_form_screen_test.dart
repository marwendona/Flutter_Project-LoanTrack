import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/features/loan/loan_form_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoanRepository extends Mock implements LoanRepository {}

void main() {
  late _MockLoanRepository repository;

  setUpAll(() {
    registerFallbackValue(Money.zero);
    registerFallbackValue(LocalDay(2026, 1, 1));
    registerFallbackValue(
      Loan(
        id: 0,
        borrowerId: 0,
        amount: Money.zero,
        loanDate: LocalDay(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    repository = _MockLoanRepository();
    when(
      () => repository.add(
        borrowerId: any(named: 'borrowerId'),
        amount: any(named: 'amount'),
        loanDate: any(named: 'loanDate'),
        promisedReturnDate: any(named: 'promisedReturnDate'),
        note: any(named: 'note'),
      ),
    ).thenAnswer((_) async => 1);
  });

  Future<void> pumpScreen(WidgetTester tester, {int? loanId}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [loanRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          theme: AppTheme.light(null),
          home: LoanFormScreen(borrowerId: 3, loanId: loanId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  FilledButton saveButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  testWidgets('shows the fields with today as default loan date', (
    tester,
  ) async {
    await withClock(Clock.fixed(DateTime(2026, 11, 4)), () async {
      await pumpScreen(tester);
    });

    expect(find.text('Nouveau prêt'), findsOneWidget);
    expect(find.text('Montant'), findsOneWidget);
    expect(find.text('TND'), findsOneWidget);
    expect(find.text('04/11/2026'), findsOneWidget);
    expect(find.text('Non définie'), findsOneWidget);
    expect(saveButton(tester).onPressed, isNull);
  });

  testWidgets('shows amount errors under the field and disables saving', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.enterText(find.byType(TextField).first, '0');
    await tester.pump();
    expect(find.text('Le montant doit être supérieur à zéro.'), findsOne);
    expect(saveButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField).first, '');
    await tester.pump();
    expect(find.text('Le montant est obligatoire.'), findsOne);
  });

  testWidgets('saves a valid loan', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byType(TextField).first, '1250,5');
    await tester.pump();
    expect(saveButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    verify(
      () => repository.add(
        borrowerId: 3,
        amount: const Money(1250500),
        loanDate: any(named: 'loanDate'),
        promisedReturnDate: null,
        note: null,
      ),
    ).called(1);
  });

  group('modification (US-2.4)', () {
    final loan = Loan(
      id: 9,
      borrowerId: 3,
      amount: const Money(1000000),
      loanDate: LocalDay(2026, 10, 1),
      note: 'voiture',
    );

    setUp(() {
      when(() => repository.getSummaryById(9)).thenAnswer(
        (_) async => LoanSummary(
          loan: loan,
          repaid: const Money(300000),
          firstRepaymentDate: LocalDay(2026, 10, 10),
        ),
      );
      when(() => repository.update(any())).thenAnswer((_) async {});
    });

    testWidgets('shows the pre-filled loan and saves the changes', (
      tester,
    ) async {
      await pumpScreen(tester, loanId: 9);

      expect(find.text('Modifier le prêt'), findsOneWidget);
      expect(find.text('1 000,000'), findsOneWidget);
      expect(find.text('01/10/2026'), findsOneWidget);
      expect(find.text('voiture'), findsOneWidget);
      expect(saveButton(tester).onPressed, isNotNull);

      await tester.enterText(find.byType(TextField).first, '1200');
      await tester.pump();
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      verify(
        () => repository.update(loan.copyWith(amount: const Money(1200000))),
      ).called(1);
    });

    testWidgets('refuses an amount below the amount repaid (RG-13)', (
      tester,
    ) async {
      await pumpScreen(tester, loanId: 9);

      await tester.enterText(find.byType(TextField).first, '200');
      await tester.pump();

      expect(
        find.text(
          'Le montant ne peut pas être inférieur au montant déjà remboursé '
          '(300,000 TND).',
        ),
        findsOneWidget,
      );
      expect(saveButton(tester).onPressed, isNull);
    });

    testWidgets('shows a message when the loan does not exist', (tester) async {
      when(() => repository.getSummaryById(9)).thenAnswer((_) async => null);

      await pumpScreen(tester, loanId: 9);

      expect(find.text("Ce prêt n'existe plus."), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
    });
  });
}
