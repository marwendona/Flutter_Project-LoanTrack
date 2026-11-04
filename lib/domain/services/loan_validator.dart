import '../../core/date/local_day.dart';
import '../../core/money/currency.dart';
import '../../core/money/money.dart';
import '../../core/money/money_parser.dart';

/// Why a loan amount typed by the user is invalid (RG-10).
enum LoanAmountError { required, invalidFormat, notPositive, tooLarge }

/// Why a loan date is invalid (RG-11).
enum LoanDateError { inFuture }

/// Why a promised return date is invalid (RG-12).
enum PromisedReturnDateError { beforeLoanDate }

/// Validation rules of a loan (RG-10 to RG-12, loan data model).
abstract final class LoanValidator {
  /// Maximum amount in major units (RG-10).
  static const maxAmountMajor = 999999999;
  static const noteMaxLength = 500;

  /// Maximum amount in minor units of [currency] (RG-10).
  static Money maxAmount(Currency currency) =>
      Money(maxAmountMajor * currency.minorUnitsPerMajor);

  /// Parses and validates the amount typed by the user (RG-10).
  static LoanAmountError? validateAmountInput(String input, Currency currency) {
    if (input.trim().isEmpty) return LoanAmountError.required;
    final amount = MoneyParser.tryParse(input, currency);
    if (amount == null) return LoanAmountError.invalidFormat;
    return validateAmount(amount, currency);
  }

  /// The amount is strictly positive and at most [maxAmount] (RG-10).
  static LoanAmountError? validateAmount(Money amount, Currency currency) {
    if (!amount.isPositive) return LoanAmountError.notPositive;
    if (amount > maxAmount(currency)) return LoanAmountError.tooLarge;
    return null;
  }

  /// The loan date cannot be after [today] (RG-11).
  static LoanDateError? validateLoanDate(LocalDay loanDate, LocalDay today) =>
      loanDate > today ? LoanDateError.inFuture : null;

  /// The optional promised return date is on or after the loan date (RG-12).
  static PromisedReturnDateError? validatePromisedReturnDate(
    LocalDay? promisedReturnDate,
    LocalDay loanDate,
  ) => promisedReturnDate != null && promisedReturnDate < loanDate
      ? PromisedReturnDateError.beforeLoanDate
      : null;

  /// The optional note is at most 500 characters long once trimmed.
  static bool isNoteValid(String note) => note.trim().length <= noteMaxLength;
}
