import '../../core/date/local_day.dart';
import '../models/borrower_reliability.dart';
import '../models/loan_balance.dart';
import '../models/reliability_color.dart';

/// Computes the punctuality of loans and the reliability color of a borrower
/// (RG-60 to RG-62) for a given [today].
///
/// [today] is always injected: in production it comes from `LocalDay.today()`,
/// which reads `clock`.
abstract final class ReliabilityCalculator {
  /// Punctuality of [loan] (RG-60, RG-61).
  ///
  /// Only the end date matters: the last repayment date for a fully repaid
  /// loan, [today] for a loan still due after its promised date.
  static LoanPunctuality loanPunctuality(LoanBalance loan, LocalDay today) {
    final promised = loan.promisedReturnDate;
    if (promised == null) return LoanPunctuality.notEvaluable;
    final LocalDay end;
    if (loan.remaining.isPositive) {
      if (!(promised < today)) return LoanPunctuality.notEvaluable;
      end = today;
    } else {
      // A fully repaid loan always has a repayment (amount > 0): the null
      // check is defensive only.
      final lastRepaymentDate = loan.lastRepaymentDate;
      if (lastRepaymentDate == null) return LoanPunctuality.notEvaluable;
      end = lastRepaymentDate;
    }
    if (end <= promised) return LoanPunctuality.onTime;
    return end <= shortDelayLimit(promised)
        ? LoanPunctuality.shortDelay
        : LoanPunctuality.longDelay;
  }

  /// Last end date of a short delay: the same day of the month following
  /// [promised], or the last day of that month if it has no such day (RG-61).
  static LocalDay shortDelayLimit(LocalDay promised) {
    final nextMonthYear = promised.month == 12
        ? promised.year + 1
        : promised.year;
    final nextMonth = promised.month == 12 ? 1 : promised.month + 1;
    // Day 0 of the month after next is the last day of the next month.
    final lastDayOfNextMonth = DateTime.utc(
      nextMonthYear,
      nextMonth + 1,
      0,
    ).day;
    final day = promised.day < lastDayOfNextMonth
        ? promised.day
        : lastDayOfNextMonth;
    return LocalDay(nextMonthYear, nextMonth, day);
  }

  /// N, L and the reliability color of a borrower from all its loans (RG-62).
  static BorrowerReliability evaluate(
    Iterable<LoanBalance> loans,
    LocalDay today,
  ) {
    var evaluated = 0;
    var late = 0;
    var longDelays = 0;
    for (final loan in loans) {
      final punctuality = loanPunctuality(loan, today);
      if (punctuality.isEvaluated) evaluated++;
      if (punctuality.isLate) late++;
      if (punctuality == LoanPunctuality.longDelay) longDelays++;
    }
    return BorrowerReliability(
      evaluatedLoanCount: evaluated,
      lateLoanCount: late,
      longDelayCount: longDelays,
      color: colorFor(
        evaluatedLoanCount: evaluated,
        lateLoanCount: late,
        longDelayCount: longDelays,
      ),
    );
  }

  /// The RG-62 table.
  static ReliabilityColor colorFor({
    required int evaluatedLoanCount,
    required int lateLoanCount,
    required int longDelayCount,
  }) {
    if (evaluatedLoanCount == 0) return ReliabilityColor.notEvaluated;
    return switch ((lateLoanCount, longDelayCount)) {
      (0, _) => ReliabilityColor.green,
      (1, 0) => ReliabilityColor.blue,
      (1, _) => ReliabilityColor.purple,
      (2, 0) => ReliabilityColor.yellow,
      (2, 1) => ReliabilityColor.orange,
      (2, _) || (3, _) => ReliabilityColor.red,
      _ => ReliabilityColor.black,
    };
  }
}
