import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/domain/repositories/repayment_repository.dart';
import 'package:loantrack/domain/services/repayment_validator.dart';
import 'package:loantrack/features/repayment/repayment_form_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepaymentRepository extends Mock implements RepaymentRepository {}

void main() {
  final today = LocalDay(2026, 11, 4);
  late _MockRepaymentRepository repository;
  late ProviderContainer container;

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

  setUpAll(() {
    registerFallbackValue(Money.zero);
    registerFallbackValue(today);
  });

  setUp(() {
    repository = _MockRepaymentRepository();
    container = ProviderContainer(
      overrides: [repaymentRepositoryProvider.overrideWithValue(repository)],
    );
    // Today is frozen when the controller is built.
    withClock(Clock.fixed(DateTime(2026, 11, 4, 23, 30)), () {
      container.listen(repaymentFormControllerProvider(loan), (_, _) {});
    });
  });
  tearDown(() => container.dispose());

  RepaymentFormController controller() =>
      container.read(repaymentFormControllerProvider(loan).notifier);
  RepaymentFormState state() =>
      container.read(repaymentFormControllerProvider(loan));

  void stubAdd(Future<int> Function() answer) => when(
    () => repository.add(
      loanId: any(named: 'loanId'),
      amount: any(named: 'amount'),
      repaymentDate: any(named: 'repaymentDate'),
      note: any(named: 'note'),
    ),
  ).thenAnswer((_) => answer());

  test('starts with today as date and the remaining amount due', () {
    expect(state().repaymentDate, today);
    expect(state().today, today);
    expect(state().loanDate, LocalDay(2026, 10, 1));
    expect(state().remaining, const Money(750000));
    expect(state().amountError, RepaymentAmountError.required);
    expect(state().isAmountDirty, isFalse);
    expect(state().canSave, isFalse);
  });

  test('validates the amount against the remaining amount due (RG-16)', () {
    controller().amountChanged('750,001');
    expect(state().isAmountDirty, isTrue);
    expect(state().amountError, RepaymentAmountError.exceedsRemaining);
    expect(state().canSave, isFalse);

    controller().amountChanged('0');
    expect(state().amountError, RepaymentAmountError.notPositive);

    controller().amountChanged('100');
    expect(state().amountError, isNull);
    expect(state().canSave, isTrue);
  });

  test('"Totalité" fills the amount with the remaining amount due (RG-18)', () {
    final input = controller().fillRemaining();

    expect(input, '750,000');
    expect(state().amountInput, '750,000');
    expect(state().amountError, isNull);
    expect(state().canSave, isTrue);
  });

  test('validates the repayment date (RG-17)', () {
    controller().amountChanged('100');

    controller().repaymentDateChanged(LocalDay(2026, 9, 30));
    expect(state().repaymentDateError, RepaymentDateError.beforeLoanDate);
    expect(state().canSave, isFalse);

    controller().repaymentDateChanged(LocalDay(2026, 11, 5));
    expect(state().repaymentDateError, RepaymentDateError.inFuture);

    controller().repaymentDateChanged(LocalDay(2026, 10, 1));
    expect(state().repaymentDateError, isNull);
    expect(state().canSave, isTrue);
  });

  test('rejects a note longer than 200 characters', () {
    controller().amountChanged('100');
    controller().noteChanged('a' * 201);

    expect(state().isNoteValid, isFalse);
    expect(state().canSave, isFalse);
  });

  test('save stores the repayment with a trimmed note', () async {
    stubAdd(() async => 1);
    controller()
      ..amountChanged('250,5')
      ..repaymentDateChanged(LocalDay(2026, 10, 20))
      ..noteChanged('  espèces  ');

    expect(await controller().save(), isTrue);

    verify(
      () => repository.add(
        loanId: 5,
        amount: const Money(250500),
        repaymentDate: LocalDay(2026, 10, 20),
        note: 'espèces',
      ),
    ).called(1);
    expect(state().isSaving, isFalse);
  });

  test('save stores no note when it is blank', () async {
    stubAdd(() async => 1);
    controller()
      ..fillRemaining()
      ..noteChanged('   ');

    expect(await controller().save(), isTrue);

    verify(
      () => repository.add(
        loanId: 5,
        amount: const Money(750000),
        repaymentDate: today,
        note: null,
      ),
    ).called(1);
  });

  test('save does nothing and shows errors when the form is invalid', () async {
    expect(await controller().save(), isFalse);

    expect(state().isAmountDirty, isTrue);
    verifyNever(
      () => repository.add(
        loanId: any(named: 'loanId'),
        amount: any(named: 'amount'),
        repaymentDate: any(named: 'repaymentDate'),
        note: any(named: 'note'),
      ),
    );
  });

  test('save reports a failure', () async {
    stubAdd(() async => throw Exception('disk full'));
    controller().amountChanged('100');

    expect(await controller().save(), isFalse);

    expect(state().hasSaveFailed, isTrue);
    expect(state().isSaving, isFalse);

    controller().amountChanged('101');
    expect(state().hasSaveFailed, isFalse);
  });
}
