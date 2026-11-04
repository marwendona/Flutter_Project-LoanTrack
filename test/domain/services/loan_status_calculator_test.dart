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
      loanDate: LocalDay(2026, 10, 1),
      promisedReturnDate: promised,
    ),
    repaid: Money(repaid),
    lastRepaymentDate: lastRepaymentDate,
  );

  LoanStatus compute(LoanSummary loan) =>
      LoanStatusCalculator.compute(loan, today);

  test('remaining due is amount minus repaid (RG-21)', () {
    expect(summary(amount: 10000, repaid: 2500).remaining, const Money(7500));
  });

  test('ongoing when nothing repaid and no promised date', () {
    expect(compute(summary()), const LoanStatus.ongoing());
  });

  test('partially repaid when something repaid and not overdue', () {
    expect(
      compute(summary(repaid: 2500, promised: LocalDay(2026, 12, 1))),
      const LoanStatus.partiallyRepaid(),
    );
  });

  test('repaid with the last repayment date when nothing remains (RG-22)', () {
    expect(
      compute(
        summary(repaid: 10000, lastRepaymentDate: LocalDay(2026, 10, 20)),
      ),
      LoanStatus.repaid(repaidOn: LocalDay(2026, 10, 20)),
    );
  });

  test('repaid even if the promised date is passed', () {
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

  test('promised date today is not overdue', () {
    expect(compute(summary(promised: today)), const LoanStatus.ongoing());
  });

  test('overdue with the number of days since the promised date (RG-23)', () {
    expect(
      compute(summary(promised: LocalDay(2026, 11, 3))),
      const LoanStatus.overdue(days: 1),
    );
    expect(
      compute(summary(repaid: 2500, promised: LocalDay(2026, 10, 25))),
      const LoanStatus.overdue(days: 10),
    );
  });
}
