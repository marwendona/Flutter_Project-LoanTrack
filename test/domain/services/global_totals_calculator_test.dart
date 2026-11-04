import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/domain/models/global_totals.dart';
import 'package:loantrack/domain/models/loan_balance.dart';
import 'package:loantrack/domain/services/global_totals_calculator.dart';

void main() {
  final today = LocalDay(2026, 11, 2);
  final yesterday = LocalDay(2026, 11, 1);

  BorrowerWithLoans entry(int id, List<LoanBalance> loans) => (
    borrower: Borrower(id: id, name: 'B$id', createdAt: LocalDay(2026, 10, 1)),
    loans: loans,
  );

  LoanBalance loan(int amount, {int repaid = 0, LocalDay? promised}) =>
      LoanBalance(
        amount: Money(amount),
        repaid: Money(repaid),
        promisedReturnDate: promised,
      );

  test('no borrower gives zero totals and a 0 % rate (RG-32)', () {
    final totals = GlobalTotalsCalculator.compute(const [], today);

    expect(totals, GlobalTotals.empty);
    expect(totals.remaining, Money.zero);
    expect(totals.repaymentRatePercent, 0);
    expect(totals.repaymentRatio, 0);
  });

  test('borrowers without loans give zero totals', () {
    final totals = GlobalTotalsCalculator.compute([
      entry(1, const []),
      entry(2, const []),
    ], today);

    expect(totals, GlobalTotals.empty);
  });

  test(
    'sums all loans of all borrowers, repaid ones included (RG-31, RG-33)',
    () {
      final totals = GlobalTotalsCalculator.compute([
        entry(1, [loan(1000000, repaid: 250000), loan(500000, repaid: 500000)]),
        entry(2, [loan(2000000)]),
        entry(3, [loan(300000, repaid: 300000)]),
      ], today);

      expect(totals.totalLent, const Money(3800000));
      expect(totals.totalRepaid, const Money(1050000));
      expect(totals.remaining, const Money(2750000));
      expect(totals.loanCount, 4);
      // Borrower 3 has repaid everything.
      expect(totals.borrowersWithRemainingCount, 2);
    },
  );

  test('counts overdue loans and sums their remaining due (RG-20, RG-31)', () {
    final totals = GlobalTotalsCalculator.compute([
      entry(1, [
        loan(1000000, repaid: 400000, promised: yesterday), // overdue: 600000
        loan(500000, promised: today), // due today: not overdue
      ]),
      entry(2, [
        loan(200000, promised: LocalDay(2026, 1, 1)), // overdue: 200000
        loan(300000, repaid: 300000, promised: yesterday), // repaid
        loan(700000), // no promised date
      ]),
    ], today);

    expect(totals.overdueLoanCount, 2);
    expect(totals.overdueAmount, const Money(800000));
  });

  group('repayment rate (RG-32)', () {
    GlobalTotals totals(int lent, int repaid) =>
        GlobalTotalsCalculator.compute([
          entry(1, [loan(lent, repaid: repaid)]),
        ], today);

    test('nothing repaid gives 0 %', () {
      expect(totals(1000, 0).repaymentRatePercent, 0);
    });

    test('half repaid gives 50 %', () {
      final half = totals(1000, 500);
      expect(half.repaymentRatePercent, 50);
      expect(half.repaymentRatio, 0.5);
    });

    test('is rounded down: 100 % only when fully repaid', () {
      expect(totals(1000000, 999999).repaymentRatePercent, 99);
      expect(totals(1000000, 1000000).repaymentRatePercent, 100);
      expect(totals(3000, 1000).repaymentRatePercent, 33);
    });

    test('handles amounts beyond 2^31 minor units', () {
      final big = totals(5000000000, 2500000000);
      expect(big.repaymentRatePercent, 50);
      expect(big.remaining, const Money(2500000000));
    });
  });
}
