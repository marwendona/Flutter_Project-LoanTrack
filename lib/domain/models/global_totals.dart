import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/money/money.dart';

part 'global_totals.freezed.dart';

/// Derived totals over all borrowers and loans (RG-31 to RG-33). Never stored.
@freezed
abstract class GlobalTotals with _$GlobalTotals {
  const factory GlobalTotals({
    required Money totalLent,
    required Money totalRepaid,
    required int loanCount,

    /// Borrowers with a remaining amount due > 0.
    required int borrowersWithRemainingCount,
    required int overdueLoanCount,

    /// Sum of the remaining amounts due of the overdue loans.
    required Money overdueAmount,
  }) = _GlobalTotals;

  const GlobalTotals._();

  static const empty = GlobalTotals(
    totalLent: Money.zero,
    totalRepaid: Money.zero,
    loanCount: 0,
    borrowersWithRemainingCount: 0,
    overdueLoanCount: 0,
    overdueAmount: Money.zero,
  );

  /// Amount still to be received from all borrowers (RG-31).
  Money get remaining => totalLent - totalRepaid;

  /// Global repayment rate in whole percent, rounded down so that 100 % only
  /// shows when everything is repaid; 0 % without any loan (RG-32).
  int get repaymentRatePercent => totalLent.isZero
      ? 0
      : totalRepaid.amountMinor * 100 ~/ totalLent.amountMinor;

  /// Repaid / lent ratio in [0, 1], for a progress bar only: amounts
  /// themselves stay integers (RG-32).
  double get repaymentRatio =>
      totalLent.isZero ? 0 : totalRepaid.amountMinor / totalLent.amountMinor;
}
