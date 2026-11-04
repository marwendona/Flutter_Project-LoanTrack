import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../models/loan_status.dart';
import '../models/loan_summary.dart';

/// Computes the status of a loan (RG-20) for a given [today].
///
/// [today] is always injected: in production it comes from `LocalDay.today()`,
/// which reads `clock`, so tests can freeze it.
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
    final days = overdueDays(
      remaining: summary.remaining,
      promisedReturnDate: summary.loan.promisedReturnDate,
      today: today,
    );
    if (days != null) return LoanStatus.overdue(days: days);
    if (summary.repaid.isPositive) return const LoanStatus.partiallyRepaid();
    return const LoanStatus.ongoing();
  }

  /// Number of days between the promised return date and [today] (RG-23), or
  /// null if the loan is not overdue.
  ///
  /// A loan is overdue when it has a promised return date strictly before
  /// [today] and a remaining amount due (RG-20): a loan due today is not
  /// overdue yet.
  static int? overdueDays({
    required Money remaining,
    required LocalDay? promisedReturnDate,
    required LocalDay today,
  }) {
    if (!remaining.isPositive) return null;
    if (promisedReturnDate == null || !(promisedReturnDate < today)) {
      return null;
    }
    return today.epochDay - promisedReturnDate.epochDay;
  }
}
