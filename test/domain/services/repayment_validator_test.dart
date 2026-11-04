import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/domain/services/repayment_validator.dart';

void main() {
  const remaining = Money(750000);

  group('validateAmountInput (RG-16)', () {
    RepaymentAmountError? validate(String input) =>
        RepaymentValidator.validateAmountInput(
          input,
          Currency.tnd,
          remaining: remaining,
        );

    test('requires an amount', () {
      expect(validate(''), RepaymentAmountError.required);
      expect(validate('   '), RepaymentAmountError.required);
    });

    test('rejects an unparsable amount', () {
      expect(validate('12,3456'), RepaymentAmountError.invalidFormat);
      expect(validate('abc'), RepaymentAmountError.invalidFormat);
    });

    test('rejects zero', () {
      expect(validate('0'), RepaymentAmountError.notPositive);
      expect(validate('0,000'), RepaymentAmountError.notPositive);
    });

    test('accepts up to the remaining amount due', () {
      expect(validate('0,001'), isNull);
      expect(validate('250'), isNull);
      expect(validate('750'), isNull);
      expect(validate('750,000'), isNull);
    });

    test('rejects more than the remaining amount due', () {
      expect(validate('750,001'), RepaymentAmountError.exceedsRemaining);
      expect(validate('1 000'), RepaymentAmountError.exceedsRemaining);
    });
  });

  group('validateRepaymentDate (RG-17)', () {
    final loanDate = LocalDay(2026, 10, 1);
    final today = LocalDay(2026, 11, 4);

    RepaymentDateError? validate(LocalDay date) =>
        RepaymentValidator.validateRepaymentDate(
          date,
          loanDate: loanDate,
          today: today,
        );

    test('accepts the loan date, today and any day in between', () {
      expect(validate(loanDate), isNull);
      expect(validate(LocalDay(2026, 10, 15)), isNull);
      expect(validate(today), isNull);
    });

    test('rejects a day before the loan date', () {
      expect(
        validate(LocalDay(2026, 9, 30)),
        RepaymentDateError.beforeLoanDate,
      );
    });

    test('rejects a day in the future', () {
      expect(validate(LocalDay(2026, 11, 5)), RepaymentDateError.inFuture);
    });
  });

  test('note is at most 200 characters once trimmed', () {
    expect(RepaymentValidator.isNoteValid(''), isTrue);
    expect(RepaymentValidator.isNoteValid('a' * 200), isTrue);
    expect(RepaymentValidator.isNoteValid('  ${'a' * 200}  '), isTrue);
    expect(RepaymentValidator.isNoteValid('a' * 201), isFalse);
  });
}
