import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_reliability.dart';
import 'package:loantrack/domain/models/loan_balance.dart';
import 'package:loantrack/domain/models/reliability_color.dart';
import 'package:loantrack/domain/services/borrower_summary_calculator.dart';

void main() {
  final today = LocalDay(2026, 11, 2);

  Borrower borrower(int id, String name) =>
      Borrower(id: id, name: name, createdAt: LocalDay(2026, 10, 1));

  LoanBalance loan(int amount, {int repaid = 0, LocalDay? promised}) =>
      LoanBalance(
        amount: Money(amount),
        repaid: Money(repaid),
        promisedReturnDate: promised,
      );

  group('isOverdue (RG-20)', () {
    test('promised date before today with remaining due', () {
      expect(
        BorrowerSummaryCalculator.isOverdue(
          loan(1000, repaid: 400, promised: LocalDay(2026, 11, 1)),
          today,
        ),
        isTrue,
      );
    });

    test('promised date today is not overdue', () {
      expect(
        BorrowerSummaryCalculator.isOverdue(loan(1000, promised: today), today),
        isFalse,
      );
    });

    test('fully repaid with a past promised date is not overdue', () {
      expect(
        BorrowerSummaryCalculator.isOverdue(
          loan(1000, repaid: 1000, promised: LocalDay(2026, 1, 1)),
          today,
        ),
        isFalse,
      );
    });

    test('no promised date is never overdue', () {
      expect(BorrowerSummaryCalculator.isOverdue(loan(1000), today), isFalse);
    });
  });

  group('summarize (RG-30)', () {
    test('borrower without loans', () {
      final summary = BorrowerSummaryCalculator.summarize(
        borrower(1, 'Ali'),
        const [],
        today,
      );
      expect(summary.totalLent, Money.zero);
      expect(summary.totalRepaid, Money.zero);
      expect(summary.remaining, Money.zero);
      expect(summary.loanCount, 0);
      expect(summary.activeLoanCount, 0);
      expect(summary.isOverdue, isFalse);
    });

    test('adds up loans and counts active and overdue loans', () {
      final summary = BorrowerSummaryCalculator.summarize(borrower(1, 'Ali'), [
        loan(1250500, repaid: 250500, promised: LocalDay(2026, 10, 31)),
        loan(500000, repaid: 500000, promised: LocalDay(2026, 10, 1)),
        loan(100000),
      ], today);
      expect(summary.totalLent, const Money(1850500));
      expect(summary.totalRepaid, const Money(750500));
      expect(summary.remaining, const Money(1100000));
      expect(summary.loanCount, 3);
      expect(summary.activeLoanCount, 2);
      expect(summary.overdueLoanCount, 1);
      expect(summary.isOverdue, isTrue);
    });
  });

  group('summarize: reliability (RG-62)', () {
    test('borrower without loans is not evaluated', () {
      final summary = BorrowerSummaryCalculator.summarize(
        borrower(1, 'Ali'),
        const [],
        today,
      );
      expect(summary.reliability, BorrowerReliability.notEvaluated);
    });

    test('counts the delays of all the loans with the day of [today]', () {
      final summary = BorrowerSummaryCalculator.summarize(borrower(1, 'Ali'), [
        // Still due, promised more than a month ago: long delay.
        loan(1000, promised: LocalDay(2026, 9, 1)),
        // Still due, promised yesterday: short delay.
        loan(1000, promised: LocalDay(2026, 11, 1)),
        // Not due yet: not evaluated.
        loan(1000, promised: LocalDay(2026, 12, 1)),
      ], today);
      expect(
        summary.reliability,
        const BorrowerReliability(
          evaluatedLoanCount: 2,
          lateLoanCount: 2,
          longDelayCount: 1,
          color: ReliabilityColor.orange,
        ),
      );
    });
  });

  group('summarizeAll (RG-04)', () {
    test('sorts by remaining due descending, then by name ignoring case', () {
      final summaries = BorrowerSummaryCalculator.summarizeAll([
        (borrower: borrower(1, 'sami'), loans: [loan(1000)]),
        (borrower: borrower(2, 'Zied'), loans: const <LoanBalance>[]),
        (borrower: borrower(3, 'Ali'), loans: [loan(5000, repaid: 1000)]),
        (borrower: borrower(4, 'Amel'), loans: [loan(1000)]),
        (borrower: borrower(5, 'bilel'), loans: [loan(800, repaid: 800)]),
      ], today);

      expect(summaries.map((s) => s.borrower.name), [
        'Ali', // 4 000 due
        'Amel', // 1 000 due
        'sami', // 1 000 due
        'bilel', // 0 due
        'Zied', // 0 due
      ]);
    });
  });
}
