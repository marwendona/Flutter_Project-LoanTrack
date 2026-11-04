import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../models/borrower_summary.dart';
import '../models/global_totals.dart';
import 'borrower_summary_calculator.dart';

/// Computes the dashboard totals over all borrowers (RG-31, RG-32), fully
/// repaid loans included (RG-33).
abstract final class GlobalTotalsCalculator {
  static GlobalTotals compute(
    Iterable<BorrowerWithLoans> entries,
    LocalDay today,
  ) {
    var totalLent = Money.zero;
    var totalRepaid = Money.zero;
    var loanCount = 0;
    var borrowersWithRemainingCount = 0;
    var overdueLoanCount = 0;
    var overdueAmount = Money.zero;
    for (final entry in entries) {
      var borrowerRemaining = Money.zero;
      for (final loan in entry.loans) {
        totalLent += loan.amount;
        totalRepaid += loan.repaid;
        loanCount++;
        borrowerRemaining += loan.remaining;
        if (BorrowerSummaryCalculator.isOverdue(loan, today)) {
          overdueLoanCount++;
          overdueAmount += loan.remaining;
        }
      }
      if (borrowerRemaining.isPositive) borrowersWithRemainingCount++;
    }
    return GlobalTotals(
      totalLent: totalLent,
      totalRepaid: totalRepaid,
      loanCount: loanCount,
      borrowersWithRemainingCount: borrowersWithRemainingCount,
      overdueLoanCount: overdueLoanCount,
      overdueAmount: overdueAmount,
    );
  }
}
