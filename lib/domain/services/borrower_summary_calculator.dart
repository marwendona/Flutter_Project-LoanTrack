import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../models/borrower.dart';
import '../models/borrower_summary.dart';
import '../models/loan_balance.dart';
import 'borrower_name_key.dart';

/// Computes the borrower totals (RG-30) and the borrowers list order (RG-04).
abstract final class BorrowerSummaryCalculator {
  /// A loan is overdue when it has a promised return date strictly before
  /// [today] and a remaining amount due (RG-20).
  static bool isOverdue(LoanBalance loan, LocalDay today) {
    final promised = loan.promisedReturnDate;
    return loan.remaining.isPositive && promised != null && promised < today;
  }

  static BorrowerSummary summarize(
    Borrower borrower,
    List<LoanBalance> loans,
    LocalDay today,
  ) {
    var totalLent = Money.zero;
    var totalRepaid = Money.zero;
    var activeLoanCount = 0;
    var overdueLoanCount = 0;
    for (final loan in loans) {
      totalLent += loan.amount;
      totalRepaid += loan.repaid;
      if (loan.remaining.isPositive) activeLoanCount++;
      if (isOverdue(loan, today)) overdueLoanCount++;
    }
    return BorrowerSummary(
      borrower: borrower,
      totalLent: totalLent,
      totalRepaid: totalRepaid,
      loanCount: loans.length,
      activeLoanCount: activeLoanCount,
      overdueLoanCount: overdueLoanCount,
    );
  }

  /// Summaries sorted by remaining due (highest first), then by name A→Z
  /// ignoring case (RG-04).
  static List<BorrowerSummary> summarizeAll(
    Iterable<BorrowerWithLoans> entries,
    LocalDay today,
  ) {
    final summaries = [
      for (final entry in entries)
        summarize(entry.borrower, entry.loans, today),
    ];
    return summaries..sort(compareByRemainingThenName);
  }

  static int compareByRemainingThenName(BorrowerSummary a, BorrowerSummary b) {
    final byRemaining = b.remaining.compareTo(a.remaining);
    if (byRemaining != 0) return byRemaining;
    final byName = borrowerNameKey(a.borrower.name)
        .compareTo(borrowerNameKey(b.borrower.name));
    if (byName != 0) return byName;
    return a.borrower.id.compareTo(b.borrower.id);
  }
}
