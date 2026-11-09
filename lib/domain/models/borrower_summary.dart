import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/money/money.dart';
import 'borrower.dart';
import 'borrower_reliability.dart';
import 'loan_balance.dart';

part 'borrower_summary.freezed.dart';

/// A borrower with the balances of all its loans: the input of the totals.
typedef BorrowerWithLoans = ({Borrower borrower, List<LoanBalance> loans});

/// Derived totals of a borrower (RG-30). Never stored.
@freezed
abstract class BorrowerSummary with _$BorrowerSummary {
  const factory BorrowerSummary({
    required Borrower borrower,
    required Money totalLent,
    required Money totalRepaid,
    required int loanCount,

    /// Loans not fully repaid (remaining due > 0).
    required int activeLoanCount,
    required int overdueLoanCount,

    /// Reliability color with N and L, of the day (RG-62, RG-63).
    required BorrowerReliability reliability,
  }) = _BorrowerSummary;

  const BorrowerSummary._();

  Money get remaining => totalLent - totalRepaid;

  bool get isOverdue => overdueLoanCount > 0;
}
