import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_status.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/domain/services/loan_status_calculator.dart';

void main() {
  final today = LocalDay(2026, 11, 4);

  LoanSummary summary({
    int amount = 10000,
    int repaid = 0,
    LocalDay? promised,
    LocalDay? lastRepaymentDate,
  }) => LoanSummary(
    loan: Loan(
      id: 1,
      borrowerId: 1,
      amount: Money(amount),
      loanDate: LocalDay(2025, 10, 1),
      promisedReturnDate: promised,
    ),
    repaid: Money(repaid),
    lastRepaymentDate: lastRepaymentDate,
  );

  LoanStatus compute(LoanSummary loan, {LocalDay? on}) =>
      LoanStatusCalculator.compute(loan, on ?? today);

  test('remaining due is amount minus repaid (RG-21)', () {
    expect(summary(amount: 10000, repaid: 2500).remaining, const Money(7500));
  });

  group('ongoing (RG-20 §4)', () {
    test('nothing repaid and no promised date', () {
      expect(compute(summary()), const LoanStatus.ongoing());
    });

    test('nothing repaid and promised date in the future', () {
      expect(
        compute(summary(promised: LocalDay(2026, 11, 5))),
        const LoanStatus.ongoing(),
      );
    });

    test('promised date today is not overdue yet', () {
      expect(compute(summary(promised: today)), const LoanStatus.ongoing());
    });
  });

  group('partially repaid (RG-20 §3)', () {
    test('something repaid and promised date in the future', () {
      expect(
        compute(summary(repaid: 2500, promised: LocalDay(2026, 12, 1))),
        const LoanStatus.partiallyRepaid(),
      );
    });

    test('something repaid and no promised date', () {
      expect(compute(summary(repaid: 1)), const LoanStatus.partiallyRepaid());
    });

    test('something repaid and promised date today', () {
      expect(
        compute(summary(repaid: 2500, promised: today)),
        const LoanStatus.partiallyRepaid(),
      );
    });

    test('one millime left is still partially repaid', () {
      expect(
        compute(summary(repaid: 9999)),
        const LoanStatus.partiallyRepaid(),
      );
    });
  });

  group('repaid (RG-20 §1, RG-22)', () {
    test('with the last repayment date when nothing remains', () {
      expect(
        compute(
          summary(repaid: 10000, lastRepaymentDate: LocalDay(2026, 10, 20)),
        ),
        LoanStatus.repaid(repaidOn: LocalDay(2026, 10, 20)),
      );
    });

    test('takes precedence over a passed promised date', () {
      expect(
        compute(
          summary(
            repaid: 10000,
            promised: LocalDay(2026, 10, 15),
            lastRepaymentDate: LocalDay(2026, 10, 30),
          ),
        ),
        LoanStatus.repaid(repaidOn: LocalDay(2026, 10, 30)),
      );
    });

    test('when repaid exceeds the amount (defensive, RG-16 forbids it)', () {
      expect(
        compute(
          summary(repaid: 10001, lastRepaymentDate: LocalDay(2026, 10, 20)),
        ),
        LoanStatus.repaid(repaidOn: LocalDay(2026, 10, 20)),
      );
    });
  });

  group('overdue (RG-20 §2, RG-23)', () {
    test('one day after the promised date', () {
      expect(
        compute(summary(promised: LocalDay(2026, 11, 3))),
        const LoanStatus.overdue(days: 1),
      );
    });

    test('takes precedence over partially repaid', () {
      expect(
        compute(summary(repaid: 2500, promised: LocalDay(2026, 10, 25))),
        const LoanStatus.overdue(days: 10),
      );
    });

    test('days counted across months and years', () {
      expect(
        compute(summary(promised: LocalDay(2025, 12, 31))),
        const LoanStatus.overdue(days: 308),
      );
    });

    test('days counted across a leap day', () {
      expect(
        compute(
          summary(promised: LocalDay(2028, 2, 28)),
          on: LocalDay(2028, 3, 1),
        ),
        const LoanStatus.overdue(days: 2),
      );
    });

    test('status follows the injected day', () {
      final loan = summary(promised: LocalDay(2026, 11, 10));
      expect(
        compute(loan, on: LocalDay(2026, 11, 9)),
        const LoanStatus.ongoing(),
      );
      expect(
        compute(loan, on: LocalDay(2026, 11, 10)),
        const LoanStatus.ongoing(),
      );
      expect(
        compute(loan, on: LocalDay(2026, 11, 11)),
        const LoanStatus.overdue(days: 1),
      );
    });
  });

  group('overdueDays (RG-20, RG-23)', () {
    int? overdueDays(int remaining, LocalDay? promised) =>
        LoanStatusCalculator.overdueDays(
          remaining: Money(remaining),
          promisedReturnDate: promised,
          today: today,
        );

    test('days since the promised date when overdue', () {
      expect(overdueDays(500, LocalDay(2026, 10, 30)), 5);
    });

    test('null without a promised date', () {
      expect(overdueDays(500, null), isNull);
    });

    test('null when the promised date is today or later', () {
      expect(overdueDays(500, today), isNull);
      expect(overdueDays(500, LocalDay(2026, 12, 1)), isNull);
    });

    test('null when nothing remains due', () {
      expect(overdueDays(0, LocalDay(2026, 1, 1)), isNull);
    });
  });
}
