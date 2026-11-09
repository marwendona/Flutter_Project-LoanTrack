import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import 'loan.dart';
import 'loan_balance.dart';

part 'loan_summary.freezed.dart';

/// A loan with its derived repayment values (RG-21, RG-22). Never stored.
@freezed
abstract class LoanSummary with _$LoanSummary {
  const factory LoanSummary({
    required Loan loan,

    /// Sum of the loan repayments (RG-21).
    required Money repaid,

    /// Date of the earliest repayment, null if there is none (RG-11, RG-17).
    LocalDay? firstRepaymentDate,

    /// Date of the most recent repayment, null if there is none (RG-22).
    LocalDay? lastRepaymentDate,
  }) = _LoanSummary;

  const LoanSummary._();

  /// Remaining amount due = amount lent − amount repaid (RG-21).
  Money get remaining => loan.amount - repaid;

  LoanBalance get balance => LoanBalance(
    amount: loan.amount,
    repaid: repaid,
    promisedReturnDate: loan.promisedReturnDate,
    lastRepaymentDate: lastRepaymentDate,
  );
}
