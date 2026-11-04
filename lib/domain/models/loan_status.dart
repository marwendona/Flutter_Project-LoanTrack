import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';

part 'loan_status.freezed.dart';

/// Derived status of a loan (RG-20). Never stored.
@freezed
sealed class LoanStatus with _$LoanStatus {
  /// Nothing repaid yet and not overdue.
  const factory LoanStatus.ongoing() = LoanOngoing;

  /// Partly repaid and not overdue.
  const factory LoanStatus.partiallyRepaid() = LoanPartiallyRepaid;

  /// Remaining due is zero; [repaidOn] is the last repayment date (RG-22).
  const factory LoanStatus.repaid({LocalDay? repaidOn}) = LoanRepaid;

  /// Promised return date passed [days] days ago with a remaining due (RG-23).
  const factory LoanStatus.overdue({required int days}) = LoanOverdue;
}
