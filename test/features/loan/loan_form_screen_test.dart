import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/providers.dart';
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

  Future<void> pumpScreen(WidgetTester tester) async {
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
          home: const LoanFormScreen(borrowerId: 3),
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
}
