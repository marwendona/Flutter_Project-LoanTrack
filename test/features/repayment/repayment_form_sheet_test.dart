import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_formatter.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/domain/repositories/repayment_repository.dart';
import 'package:loantrack/features/repayment/repayment_form_sheet.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepaymentRepository extends Mock implements RepaymentRepository {}

void main() {
  late _MockRepaymentRepository repository;

  // 1 000 TND lent on 01/10/2026, 250 TND already repaid: 750 TND remaining.
  final loan = LoanSummary(
    loan: Loan(
      id: 5,
      borrowerId: 7,
      amount: const Money(1000000),
      loanDate: LocalDay(2026, 10, 1),
    ),
    repaid: const Money(250000),
  );

  String tnd(int amountMinor) =>
      MoneyFormatter.format(Money(amountMinor), Currency.tnd);

  setUpAll(() {
    registerFallbackValue(Money.zero);
    registerFallbackValue(LocalDay(2026, 1, 1));
  });

  setUp(() {
    repository = _MockRepaymentRepository();
    when(
      () => repository.add(
        loanId: any(named: 'loanId'),
        amount: any(named: 'amount'),
        repaymentDate: any(named: 'repaymentDate'),
        note: any(named: 'note'),
      ),
    ).thenAnswer((_) async => 1);
  });

  /// Opens the sheet from a button, as ECR-03 does.
  Future<void> openSheet(WidgetTester tester) async {
    await withClock(Clock.fixed(DateTime(2026, 11, 4)), () async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            repaymentRepositoryProvider.overrideWithValue(repository),
          ],
          child: MaterialApp(
            locale: const Locale('fr'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            theme: AppTheme.light(null),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showRepaymentFormSheet(context, loan),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    });
  }

  FilledButton saveButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  testWidgets('shows the fields, today as date and the remaining amount due', (
    tester,
  ) async {
    await openSheet(tester);

    expect(find.text('Nouveau remboursement'), findsOneWidget);
    expect(find.text('Reste dû : ${tnd(750000)}'), findsOneWidget);
    expect(find.text('Montant remboursé'), findsOneWidget);
    expect(find.text('TND'), findsOneWidget);
    expect(find.text('Totalité'), findsOneWidget);
    expect(find.text('Date du remboursement'), findsOneWidget);
    expect(find.text('04/11/2026'), findsOneWidget);
    expect(find.text('Note (facultative)'), findsOneWidget);
    expect(saveButton(tester).onPressed, isNull);
  });

  testWidgets('refuses an amount above the remaining amount due (RG-16)', (
    tester,
  ) async {
    await openSheet(tester);

    await tester.enterText(find.byType(TextField).first, '800');
    await tester.pump();

    expect(
      find.text(
        'Le montant ne peut pas dépasser le reste dû (${tnd(750000)}).',
      ),
      findsOneWidget,
    );
    expect(saveButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField).first, '0');
    await tester.pump();
    expect(find.text('Le montant doit être supérieur à zéro.'), findsOneWidget);
  });

  testWidgets('"Totalité" fills the remaining amount due and saves (RG-18)', (
    tester,
  ) async {
    await openSheet(tester);

    await tester.tap(find.text('Totalité'));
    await tester.pump();

    expect(find.text('750,000'), findsOneWidget);
    expect(saveButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    verify(
      () => repository.add(
        loanId: 5,
        amount: const Money(750000),
        repaymentDate: LocalDay(2026, 11, 4),
        note: null,
      ),
    ).called(1);
    expect(find.text('Nouveau remboursement'), findsNothing);
  });

  testWidgets('saves a partial repayment with its note', (tester) async {
    await openSheet(tester);

    await tester.enterText(find.byType(TextField).first, '100,5');
    await tester.enterText(find.byType(TextField).last, 'espèces');
    await tester.pump();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    verify(
      () => repository.add(
        loanId: 5,
        amount: const Money(100500),
        repaymentDate: LocalDay(2026, 11, 4),
        note: 'espèces',
      ),
    ).called(1);
  });

  testWidgets('"Annuler" closes the sheet without saving', (tester) async {
    await openSheet(tester);

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(find.text('Nouveau remboursement'), findsNothing);
    verifyNever(
      () => repository.add(
        loanId: any(named: 'loanId'),
        amount: any(named: 'amount'),
        repaymentDate: any(named: 'repaymentDate'),
        note: any(named: 'note'),
      ),
    );
  });
}
