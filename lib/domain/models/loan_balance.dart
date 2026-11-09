import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';
import '../../core/money/money.dart';

part 'loan_balance.freezed.dart';

/// A loan with the sum of its repayments, as needed for the totals (RG-21)
/// and the reliability (RG-60).
@freezed
abstract class LoanBalance with _$LoanBalance {
  const factory LoanBalance({
    required Money amount,
    required Money repaid,
    LocalDay? promisedReturnDate,

    /// Date of the most recent repayment, null if there is none (RG-22).
    LocalDay? lastRepaymentDate,
  }) = _LoanBalance;

  const LoanBalance._();

  /// Remaining amount due = amount lent − amount repaid (RG-21).
  Money get remaining => amount - repaid;
}
