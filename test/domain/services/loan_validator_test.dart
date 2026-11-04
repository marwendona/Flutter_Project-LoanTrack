import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/domain/services/loan_validator.dart';

void main() {
  const tnd = Currency.tnd;
  const eur = Currency(code: 'EUR', decimals: 2);

  group('amount (RG-10)', () {
    test('accepts a positive amount', () {
      expect(LoanValidator.validateAmountInput('1250,5', tnd), isNull);
      expect(LoanValidator.validateAmountInput('0,001', tnd), isNull);
    });

    test('requires a value', () {
      expect(
        LoanValidator.validateAmountInput('  ', tnd),
        LoanAmountError.required,
      );
    });

    test('rejects an unreadable value or too many decimals', () {
      expect(
        LoanValidator.validateAmountInput('12a', tnd),
        LoanAmountError.invalidFormat,
      );
      expect(
        LoanValidator.validateAmountInput('1,2345', tnd),
        LoanAmountError.invalidFormat,
      );
      expect(
        LoanValidator.validateAmountInput('1,234', eur),
        LoanAmountError.invalidFormat,
      );
    });

    test('rejects zero', () {
      expect(
        LoanValidator.validateAmountInput('0,000', tnd),
        LoanAmountError.notPositive,
      );
      expect(
        LoanValidator.validateAmount(Money.zero, tnd),
        LoanAmountError.notPositive,
      );
    });

    test('accepts 999 999 999 major units, not more', () {
      expect(LoanValidator.validateAmountInput('999 999 999', tnd), isNull);
      expect(
        LoanValidator.validateAmountInput('999999999,001', tnd),
        LoanAmountError.tooLarge,
      );
      expect(LoanValidator.maxAmount(eur), const Money(99999999900));
    });
  });

  group('amount of a modified loan (RG-13)', () {
    const repaid = Money(300000);

    test('accepts the amount already repaid and more', () {
      expect(
        LoanValidator.validateAmountInput('300', tnd, repaid: repaid),
        isNull,
      );
      expect(
        LoanValidator.validateAmount(const Money(300001), tnd, repaid: repaid),
        isNull,
      );
    });

    test('rejects less than the amount already repaid', () {
      expect(
        LoanValidator.validateAmountInput('299,999', tnd, repaid: repaid),
        LoanAmountError.belowRepaid,
      );
    });

    test('still rejects zero as not positive', () {
      expect(
        LoanValidator.validateAmountInput('0', tnd, repaid: repaid),
        LoanAmountError.notPositive,
      );
    });
  });

  group('loan date (RG-11)', () {
    final today = LocalDay(2026, 11, 4);

    test('accepts today and past days', () {
      expect(LoanValidator.validateLoanDate(today, today), isNull);
      expect(
        LoanValidator.validateLoanDate(LocalDay(2020, 1, 1), today),
        isNull,
      );
    });

    test('rejects a future day', () {
      expect(
        LoanValidator.validateLoanDate(LocalDay(2026, 11, 5), today),
        LoanDateError.inFuture,
      );
    });

    test('of a modified loan is not after its first repayment (RG-17)', () {
      final firstRepayment = LocalDay(2026, 10, 10);
      expect(
        LoanValidator.validateLoanDate(
          firstRepayment,
          today,
          firstRepaymentDate: firstRepayment,
        ),
        isNull,
      );
      expect(
        LoanValidator.validateLoanDate(
          LocalDay(2026, 10, 11),
          today,
          firstRepaymentDate: firstRepayment,
        ),
        LoanDateError.afterFirstRepayment,
      );
    });
  });

  group('promised return date (RG-12)', () {
    final loanDate = LocalDay(2026, 11, 4);

    test('is optional', () {
      expect(LoanValidator.validatePromisedReturnDate(null, loanDate), isNull);
    });

    test('accepts the loan date and later days', () {
      expect(
        LoanValidator.validatePromisedReturnDate(loanDate, loanDate),
        isNull,
      );
      expect(
        LoanValidator.validatePromisedReturnDate(
          LocalDay(2026, 12, 1),
          loanDate,
        ),
        isNull,
      );
    });

    test('rejects a day before the loan date', () {
      expect(
        LoanValidator.validatePromisedReturnDate(
          LocalDay(2026, 11, 3),
          loanDate,
        ),
        PromisedReturnDateError.beforeLoanDate,
      );
    });
  });

  test('note is at most 500 characters once trimmed', () {
    expect(LoanValidator.isNoteValid(' ${'a' * 500} '), isTrue);
    expect(LoanValidator.isNoteValid('a' * 501), isFalse);
  });
}
