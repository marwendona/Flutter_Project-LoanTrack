import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/domain/models/borrower_reliability.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_balance.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/domain/models/reliability_color.dart';
import 'package:loantrack/domain/services/reliability_calculator.dart';

void main() {
  final today = LocalDay(2026, 11, 9);

  /// A fully repaid loan whose last repayment was on [repaidOn].
  LoanBalance repaid({LocalDay? promised, required LocalDay repaidOn}) =>
      LoanBalance(
        amount: const Money(1000),
        repaid: const Money(1000),
        promisedReturnDate: promised,
        lastRepaymentDate: repaidOn,
      );

  /// A loan with a remaining amount due, partially repaid on [repaidOn].
  LoanBalance unpaid({LocalDay? promised, LocalDay? repaidOn}) => LoanBalance(
    amount: const Money(1000),
    repaid: repaidOn == null ? Money.zero : const Money(400),
    promisedReturnDate: promised,
    lastRepaymentDate: repaidOn,
  );

  LoanPunctuality punctuality(LoanBalance loan, {LocalDay? on}) =>
      ReliabilityCalculator.loanPunctuality(loan, on ?? today);

  /// A loan promised for 2026-03-15 and fully repaid late: 5 days late
  /// (short) or one month and one day late (long).
  LoanBalance repaidLate({required bool long}) {
    final promised = LocalDay(2026, 3, 15);
    return repaid(
      promised: promised,
      repaidOn: long ? LocalDay(2026, 4, 16) : LocalDay(2026, 3, 20),
    );
  }

  final onTime = repaid(
    promised: LocalDay(2026, 3, 15),
    repaidOn: LocalDay(2026, 3, 1),
  );

  ReliabilityColor colorOf(List<LoanBalance> loans) =>
      ReliabilityCalculator.evaluate(loans, today).color;

  group('ReliabilityColor (RG-64)', () {
    test('is declared from the most to the least reliable', () {
      expect(ReliabilityColor.values, [
        ReliabilityColor.green,
        ReliabilityColor.blue,
        ReliabilityColor.purple,
        ReliabilityColor.yellow,
        ReliabilityColor.orange,
        ReliabilityColor.red,
        ReliabilityColor.black,
        ReliabilityColor.notEvaluated,
      ]);
    });

    test('sorts in the RG-64 order', () {
      final colors = [
        ReliabilityColor.notEvaluated,
        ReliabilityColor.black,
        ReliabilityColor.green,
        ReliabilityColor.orange,
      ]..sort();
      expect(colors, [
        ReliabilityColor.green,
        ReliabilityColor.orange,
        ReliabilityColor.black,
        ReliabilityColor.notEvaluated,
      ]);
    });
  });

  group('loan punctuality (RG-60)', () {
    test('a loan without promised date is never evaluable', () {
      expect(
        punctuality(repaid(repaidOn: LocalDay(2026, 1, 1))),
        LoanPunctuality.notEvaluable,
      );
      expect(punctuality(unpaid()), LoanPunctuality.notEvaluable);
    });

    test('an unpaid loan not due yet is not evaluable', () {
      expect(
        punctuality(unpaid(promised: LocalDay(2026, 11, 10))),
        LoanPunctuality.notEvaluable,
      );
    });

    test('an unpaid loan due today is not evaluable yet', () {
      expect(
        punctuality(unpaid(promised: today, repaidOn: LocalDay(2026, 11, 1))),
        LoanPunctuality.notEvaluable,
      );
    });

    test('repaid before the promised date is on time', () {
      expect(punctuality(onTime), LoanPunctuality.onTime);
    });

    test('repaid on the promised date is on time', () {
      final promised = LocalDay(2026, 3, 15);
      expect(
        punctuality(repaid(promised: promised, repaidOn: promised)),
        LoanPunctuality.onTime,
      );
    });

    test('repaid early with a promised date still in the future is on '
        'time', () {
      expect(
        punctuality(
          repaid(
            promised: LocalDay(2027, 1, 1),
            repaidOn: LocalDay(2026, 11, 1),
          ),
        ),
        LoanPunctuality.onTime,
      );
    });

    test('repaid one day after the promised date is late', () {
      expect(
        punctuality(
          repaid(
            promised: LocalDay(2026, 3, 15),
            repaidOn: LocalDay(2026, 3, 16),
          ),
        ),
        LoanPunctuality.shortDelay,
      );
    });

    test('only the end date matters, not earlier partial repayments', () {
      // Partially repaid before the promised date, finished after it.
      expect(
        punctuality(
          repaid(
            promised: LocalDay(2026, 3, 15),
            repaidOn: LocalDay(2026, 3, 18),
          ),
        ),
        LoanPunctuality.shortDelay,
      );
    });

    test('an unpaid overdue loan is late until today (Q-10)', () {
      final promised = LocalDay(2026, 10, 9);
      final loan = unpaid(promised: promised, repaidOn: LocalDay(2026, 10, 1));

      expect(punctuality(loan), LoanPunctuality.shortDelay);
      // The delay keeps running: it becomes long after one month.
      expect(
        punctuality(loan, on: LocalDay(2026, 11, 10)),
        LoanPunctuality.longDelay,
      );
    });

    test('a promised date that passes makes an unpaid loan late', () {
      final loan = unpaid(promised: today);

      expect(punctuality(loan), LoanPunctuality.notEvaluable);
      expect(
        punctuality(loan, on: LocalDay(2026, 11, 10)),
        LoanPunctuality.shortDelay,
      );
    });
  });

  group('short / long delay (RG-61)', () {
    test('a delay of exactly one month is short', () {
      expect(
        punctuality(
          repaid(
            promised: LocalDay(2026, 3, 15),
            repaidOn: LocalDay(2026, 4, 15),
          ),
        ),
        LoanPunctuality.shortDelay,
      );
    });

    test('a delay of one month and one day is long', () {
      expect(
        punctuality(
          repaid(
            promised: LocalDay(2026, 3, 15),
            repaidOn: LocalDay(2026, 4, 16),
          ),
        ),
        LoanPunctuality.longDelay,
      );
    });

    test('promised at the end of January: the limit is the end of '
        'February', () {
      final promised = LocalDay(2027, 1, 31);
      expect(
        ReliabilityCalculator.shortDelayLimit(promised),
        LocalDay(2027, 2, 28),
      );
      expect(
        punctuality(
          repaid(promised: promised, repaidOn: LocalDay(2027, 2, 28)),
          on: LocalDay(2027, 6, 1),
        ),
        LoanPunctuality.shortDelay,
      );
      expect(
        punctuality(
          repaid(promised: promised, repaidOn: LocalDay(2027, 3, 1)),
          on: LocalDay(2027, 6, 1),
        ),
        LoanPunctuality.longDelay,
      );
    });

    test('limit in a leap year and across the year end', () {
      expect(
        ReliabilityCalculator.shortDelayLimit(LocalDay(2028, 1, 30)),
        LocalDay(2028, 2, 29),
      );
      expect(
        ReliabilityCalculator.shortDelayLimit(LocalDay(2026, 3, 31)),
        LocalDay(2026, 4, 30),
      );
      expect(
        ReliabilityCalculator.shortDelayLimit(LocalDay(2026, 12, 31)),
        LocalDay(2027, 1, 31),
      );
      expect(
        ReliabilityCalculator.shortDelayLimit(LocalDay(2026, 12, 15)),
        LocalDay(2027, 1, 15),
      );
    });
  });

  group('borrower reliability (RG-62)', () {
    test('no loan: not evaluated', () {
      expect(
        ReliabilityCalculator.evaluate(const [], today),
        const BorrowerReliability(
          evaluatedLoanCount: 0,
          lateLoanCount: 0,
          longDelayCount: 0,
          color: ReliabilityColor.notEvaluated,
        ),
      );
    });

    test('only loans not due yet or without promised date: not evaluated', () {
      expect(
        colorOf([
          unpaid(),
          unpaid(promised: LocalDay(2026, 12, 1)),
          repaid(repaidOn: LocalDay(2026, 1, 1)),
        ]),
        ReliabilityColor.notEvaluated,
      );
    });

    test('every evaluated loan on time: green', () {
      expect(
        colorOf([onTime, onTime, unpaid(promised: LocalDay(2026, 12, 1))]),
        ReliabilityColor.green,
      );
    });

    test('non evaluable loans are ignored in N and L', () {
      final reliability = ReliabilityCalculator.evaluate([
        onTime,
        repaidLate(long: true),
        unpaid(),
        unpaid(promised: LocalDay(2026, 12, 1)),
      ], today);

      expect(
        reliability,
        const BorrowerReliability(
          evaluatedLoanCount: 2,
          lateLoanCount: 1,
          longDelayCount: 1,
          color: ReliabilityColor.purple,
        ),
      );
    });

    test('N = 1, L = 0: blue', () {
      expect(colorOf([onTime, repaidLate(long: false)]), ReliabilityColor.blue);
    });

    test('N = 1, L = 1: purple', () {
      expect(colorOf([repaidLate(long: true)]), ReliabilityColor.purple);
    });

    test('N = 2, L = 0: yellow', () {
      expect(
        colorOf([repaidLate(long: false), repaidLate(long: false)]),
        ReliabilityColor.yellow,
      );
    });

    test('N = 2, L = 1: orange', () {
      expect(
        colorOf([repaidLate(long: false), repaidLate(long: true)]),
        ReliabilityColor.orange,
      );
    });

    test('N = 2, L = 2: red (Q-11)', () {
      expect(
        colorOf([repaidLate(long: true), repaidLate(long: true)]),
        ReliabilityColor.red,
      );
    });

    test('N = 3: red whatever L', () {
      for (var longCount = 0; longCount <= 3; longCount++) {
        expect(
          colorOf([
            for (var i = 0; i < 3; i++) repaidLate(long: i < longCount),
          ]),
          ReliabilityColor.red,
          reason: 'L = $longCount',
        );
      }
    });

    test('N = 4 and more: black', () {
      expect(
        colorOf([for (var i = 0; i < 4; i++) repaidLate(long: false)]),
        ReliabilityColor.black,
      );
      expect(
        colorOf([for (var i = 0; i < 7; i++) repaidLate(long: true)]),
        ReliabilityColor.black,
      );
    });

    test('loans repaid long ago still count', () {
      expect(
        colorOf([
          repaid(
            promised: LocalDay(2020, 1, 1),
            repaidOn: LocalDay(2020, 1, 5),
          ),
        ]),
        ReliabilityColor.blue,
      );
    });

    test('an unpaid overdue loan counts as a late loan', () {
      final reliability = ReliabilityCalculator.evaluate([
        onTime,
        unpaid(promised: LocalDay(2026, 9, 1)),
      ], today);

      expect(reliability.lateLoanCount, 1);
      expect(reliability.longDelayCount, 1);
      expect(reliability.color, ReliabilityColor.purple);
    });
  });

  test('LoanSummary.balance carries the last repayment date', () {
    final summary = LoanSummary(
      loan: Loan(
        id: 1,
        borrowerId: 1,
        amount: const Money(1000),
        loanDate: LocalDay(2026, 3, 1),
        promisedReturnDate: LocalDay(2026, 3, 15),
      ),
      repaid: const Money(1000),
      lastRepaymentDate: LocalDay(2026, 3, 20),
    );

    expect(summary.balance.lastRepaymentDate, LocalDay(2026, 3, 20));
    expect(
      ReliabilityCalculator.loanPunctuality(summary.balance, today),
      LoanPunctuality.shortDelay,
    );
  });
}
