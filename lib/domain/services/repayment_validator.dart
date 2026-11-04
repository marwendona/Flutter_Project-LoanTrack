import '../../core/date/local_day.dart';
import '../../core/money/currency.dart';
import '../../core/money/money.dart';
import '../../core/money/money_parser.dart';

/// Why a repayment amount typed by the user is invalid (RG-16).
enum RepaymentAmountError {
  required,
  invalidFormat,
  notPositive,

  /// Above the remaining amount due of the loan (RG-16).
  exceedsRemaining,
}

/// Why a repayment date is invalid (RG-17).
enum RepaymentDateError { beforeLoanDate, inFuture }

/// Validation rules of a repayment (RG-16, RG-17, repayment data model).
abstract final class RepaymentValidator {
  static const noteMaxLength = 200;

  /// Parses and validates the amount typed by the user (RG-16).
  static RepaymentAmountError? validateAmountInput(
    String input,
    Currency currency, {
    required Money remaining,
  }) {
    if (input.trim().isEmpty) return RepaymentAmountError.required;
    final amount = MoneyParser.tryParse(input, currency);
    if (amount == null) return RepaymentAmountError.invalidFormat;
    return validateAmount(amount, remaining: remaining);
  }

  /// The amount is strictly positive and at most the [remaining] amount due
  /// of the loan (RG-16).
  static RepaymentAmountError? validateAmount(
    Money amount, {
    required Money remaining,
  }) {
    if (!amount.isPositive) return RepaymentAmountError.notPositive;
    if (amount > remaining) return RepaymentAmountError.exceedsRemaining;
    return null;
  }

  /// The repayment date is on or after the [loanDate] and not after [today]
  /// (RG-17).
  static RepaymentDateError? validateRepaymentDate(
    LocalDay repaymentDate, {
    required LocalDay loanDate,
    required LocalDay today,
  }) {
    if (repaymentDate < loanDate) return RepaymentDateError.beforeLoanDate;
    if (repaymentDate > today) return RepaymentDateError.inFuture;
    return null;
  }

  /// The optional note is at most 200 characters long once trimmed.
  static bool isNoteValid(String note) => note.trim().length <= noteMaxLength;
}
