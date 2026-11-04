import '../../core/date/local_day.dart';
import '../models/loan_status.dart';
import '../models/loan_summary.dart';

/// Computes the status of a loan (RG-20) for a given [today].
abstract final class LoanStatusCalculator {
  /// Rules are evaluated in the RG-20 order:
  /// 1. repaid if the remaining due is zero;
  /// 2. overdue if the promised return date is strictly before [today];
  /// 3. partially repaid if something was repaid;
  /// 4. ongoing otherwise.
  static LoanStatus compute(LoanSummary summary, LocalDay today) {
    if (!summary.remaining.isPositive) {
      return LoanStatus.repaid(repaidOn: summary.lastRepaymentDate);
    }
    final promised = summary.loan.promisedReturnDate;
    if (promised != null && promised < today) {
      // Number of days between the promised date and today (RG-23).
      return LoanStatus.overdue(days: today.epochDay - promised.epochDay);
    }
    if (summary.repaid.isPositive) return const LoanStatus.partiallyRepaid();
    return const LoanStatus.ongoing();
  }
}
