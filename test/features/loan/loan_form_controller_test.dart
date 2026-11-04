import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/domain/services/loan_validator.dart';
import 'package:loantrack/features/loan/loan_form_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoanRepository extends Mock implements LoanRepository {}

void main() {
  final today = LocalDay(2026, 11, 4);
  late _MockLoanRepository repository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(Money.zero);
    registerFallbackValue(today);
  });

  setUp(() {
    repository = _MockLoanRepository();
    container = ProviderContainer(
      overrides: [loanRepositoryProvider.overrideWithValue(repository)],
    );
    // Today is frozen when the controller is built.
    withClock(Clock.fixed(DateTime(2026, 11, 4, 23, 30)), () {
      container.listen(loanFormControllerProvider, (_, _) {});
    });
  });
  tearDown(() => container.dispose());

  LoanFormController controller() =>
      container.read(loanFormControllerProvider.notifier);
  LoanFormState state() => container.read(loanFormControllerProvider);

  void stubAdd(Future<int> Function() answer) => when(
    () => repository.add(
      borrowerId: any(named: 'borrowerId'),
      amount: any(named: 'amount'),
      loanDate: any(named: 'loanDate'),
      promisedReturnDate: any(named: 'promisedReturnDate'),
      note: any(named: 'note'),
    ),
  ).thenAnswer((_) => answer());

  test('starts with today as loan date and cannot be saved yet', () {
    expect(state().loanDate, today);
    expect(state().promisedReturnDate, isNull);
    expect(state().amountError, LoanAmountError.required);
    expect(state().isAmountDirty, isFalse);
    expect(state().canSave, isFalse);
  });

  test('saves a valid loan with amount in minor units', () async {
    stubAdd(() async => 1);
    controller()
      ..amountChanged('1 250,5')
      ..loanDateChanged(LocalDay(2026, 11, 1))
      ..promisedReturnDateChanged(LocalDay(2026, 12, 1))
      ..noteChanged('  pour la voiture  ');
    expect(state().canSave, isTrue);

    final saved = await controller().save(7);

    expect(saved, isTrue);
    verify(
      () => repository.add(
        borrowerId: 7,
        amount: const Money(1250500),
        loanDate: LocalDay(2026, 11, 1),
        promisedReturnDate: LocalDay(2026, 12, 1),
        note: 'pour la voiture',
      ),
    ).called(1);
    expect(state().isSaving, isFalse);
  });

  test('stores an empty note as null', () async {
    stubAdd(() async => 1);
    controller()
      ..amountChanged('10')
      ..noteChanged('   ');

    await controller().save(1);

    verify(
      () => repository.add(
        borrowerId: 1,
        amount: const Money(10000),
        loanDate: today,
        promisedReturnDate: null,
        note: null,
      ),
    ).called(1);
  });

  test('refuses a future loan date (RG-11)', () async {
    controller()
      ..amountChanged('10')
      ..loanDateChanged(LocalDay(2026, 11, 5));

    expect(state().loanDateError, LoanDateError.inFuture);
    expect(await controller().save(1), isFalse);
    verifyNever(
      () => repository.add(
        borrowerId: any(named: 'borrowerId'),
        amount: any(named: 'amount'),
        loanDate: any(named: 'loanDate'),
        promisedReturnDate: any(named: 'promisedReturnDate'),
        note: any(named: 'note'),
      ),
    );
  });

  test('refuses a promised date before the loan date (RG-12)', () {
    controller()
      ..amountChanged('10')
      ..promisedReturnDateChanged(LocalDay(2026, 11, 3));
    expect(
      state().promisedReturnDateError,
      PromisedReturnDateError.beforeLoanDate,
    );
    expect(state().canSave, isFalse);

    controller().promisedReturnDateChanged(null);
    expect(state().canSave, isTrue);
  });

  test('refuses an invalid amount (RG-10)', () async {
    controller().amountChanged('0');
    expect(state().amountError, LoanAmountError.notPositive);
    expect(state().isAmountDirty, isTrue);
    expect(await controller().save(1), isFalse);
  });

  test('reports an unexpected save failure', () async {
    stubAdd(() async => throw Exception('disk full'));
    controller().amountChanged('10');

    final saved = await controller().save(1);

    expect(saved, isFalse);
    expect(state().hasSaveFailed, isTrue);
    expect(state().isSaving, isFalse);
    controller().amountChanged('11');
    expect(state().hasSaveFailed, isFalse);
  });
}
