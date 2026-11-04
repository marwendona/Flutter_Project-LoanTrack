import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/domain/services/loan_validator.dart';
import 'package:loantrack/features/loan/loan_form_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoanRepository extends Mock implements LoanRepository {}

void main() {
  final today = LocalDay(2026, 11, 4);
  late _MockLoanRepository repository;
  late ProviderContainer container;

  final existingLoan = Loan(
    id: 5,
    borrowerId: 7,
    amount: const Money(1000000),
    loanDate: LocalDay(2026, 10, 1),
    promisedReturnDate: LocalDay(2026, 12, 1),
    note: 'voiture',
  );
  final existing = LoanSummary(
    loan: existingLoan,
    repaid: const Money(300000),
    firstRepaymentDate: LocalDay(2026, 10, 10),
    lastRepaymentDate: LocalDay(2026, 10, 20),
  );

  const LoanFormTarget newTarget = (borrowerId: 7, existing: null);
  final LoanFormTarget editTarget = (borrowerId: 7, existing: existing);

  setUpAll(() {
    registerFallbackValue(Money.zero);
    registerFallbackValue(today);
    registerFallbackValue(existingLoan);
  });

  setUp(() {
    repository = _MockLoanRepository();
    container = ProviderContainer(
      overrides: [loanRepositoryProvider.overrideWithValue(repository)],
    );
    // Today is frozen when the controllers are built.
    withClock(Clock.fixed(DateTime(2026, 11, 4, 23, 30)), () {
      container.listen(loanFormControllerProvider(newTarget), (_, _) {});
      container.listen(loanFormControllerProvider(editTarget), (_, _) {});
    });
  });
  tearDown(() => container.dispose());

  LoanFormController controller([LoanFormTarget? target]) =>
      container.read(loanFormControllerProvider(target ?? newTarget).notifier);
  LoanFormState state([LoanFormTarget? target]) =>
      container.read(loanFormControllerProvider(target ?? newTarget));

  void stubAdd(Future<int> Function() answer) => when(
    () => repository.add(
      borrowerId: any(named: 'borrowerId'),
      amount: any(named: 'amount'),
      loanDate: any(named: 'loanDate'),
      promisedReturnDate: any(named: 'promisedReturnDate'),
      note: any(named: 'note'),
    ),
  ).thenAnswer((_) => answer());

  group('creation', () {
    test('starts with today as loan date and cannot be saved yet', () {
      expect(state().isEditing, isFalse);
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

      final saved = await controller().save();

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

      await controller().save();

      verify(
        () => repository.add(
          borrowerId: 7,
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
      expect(await controller().save(), isFalse);
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
      expect(await controller().save(), isFalse);
    });

    test('reports an unexpected save failure', () async {
      stubAdd(() async => throw Exception('disk full'));
      controller().amountChanged('10');

      final saved = await controller().save();

      expect(saved, isFalse);
      expect(state().hasSaveFailed, isTrue);
      expect(state().isSaving, isFalse);
      controller().amountChanged('11');
      expect(state().hasSaveFailed, isFalse);
    });
  });

  group('modification (US-2.4)', () {
    test('is pre-filled with the loan and can be saved as is', () {
      final s = state(editTarget);
      expect(s.isEditing, isTrue);
      expect(s.amountError, isNull);
      expect(s.amountInput, '1 000,000');
      expect(s.loanDate, LocalDay(2026, 10, 1));
      expect(s.promisedReturnDate, LocalDay(2026, 12, 1));
      expect(s.note, 'voiture');
      expect(s.repaid, const Money(300000));
      expect(s.canSave, isTrue);
    });

    test('updates the loan', () async {
      when(() => repository.update(any())).thenAnswer((_) async {});
      controller(editTarget)
        ..amountChanged('1200')
        ..loanDateChanged(LocalDay(2026, 9, 30))
        ..promisedReturnDateChanged(null)
        ..noteChanged('  ');

      expect(await controller(editTarget).save(), isTrue);

      verify(
        () => repository.update(
          existingLoan.copyWith(
            amount: const Money(1200000),
            loanDate: LocalDay(2026, 9, 30),
            promisedReturnDate: null,
            note: null,
          ),
        ),
      ).called(1);
    });

    test('refuses an amount below the amount already repaid (RG-13)', () {
      controller(editTarget).amountChanged('299,999');
      expect(state(editTarget).amountError, LoanAmountError.belowRepaid);
      expect(state(editTarget).canSave, isFalse);

      controller(editTarget).amountChanged('300');
      expect(state(editTarget).amountError, isNull);
    });

    test('refuses a loan date after the first repayment (RG-11, RG-17)', () {
      controller(editTarget).loanDateChanged(LocalDay(2026, 10, 11));
      expect(
        state(editTarget).loanDateError,
        LoanDateError.afterFirstRepayment,
      );
      expect(state(editTarget).canSave, isFalse);

      controller(editTarget).loanDateChanged(LocalDay(2026, 10, 10));
      expect(state(editTarget).loanDateError, isNull);
    });

    test('reports a loan deleted in the meantime', () async {
      when(() => repository.update(any()))
          .thenThrow(const LoanNotFoundException(5));

      expect(await controller(editTarget).save(), isFalse);
      expect(state(editTarget).hasSaveFailed, isTrue);
    });
  });
}
