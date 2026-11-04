import '../../core/money/currency.dart';
import '../../core/money/money.dart';
import '../../domain/services/borrower_name_key.dart';
import '../../domain/services/borrower_validator.dart';
import '../../domain/services/loan_validator.dart';
import '../../domain/services/repayment_validator.dart';
import 'backup_dto.dart';

/// Why a backup file is refused (RG-51).
enum InvalidBackupReason {
  /// Not a well-formed backup, or data breaking a business rule.
  invalid,

  /// A `formatVersion` this app cannot read.
  unsupportedVersion,
}

/// Thrown when a backup file is refused; nothing has been modified (RG-51).
final class InvalidBackupException implements Exception {
  const InvalidBackupException(this.reason, this.message);

  final InvalidBackupReason reason;

  /// Technical detail, for logs and tests only (never displayed).
  final String message;

  @override
  String toString() => 'InvalidBackupException(${reason.name}): $message';
}

/// Checks the whole content of a backup before anything is written (RG-51):
/// known currency, unique ids, existing references and business rules
/// (RG-01, RG-02, RG-10, RG-12, RG-16, RG-17, note lengths).
///
/// The "not in the future" rules (RG-11, RG-17) are not checked: they depend
/// on the day of entry, and a genuine backup cannot break them (CR-029).
abstract final class BackupValidator {
  /// Throws an [InvalidBackupException] at the first problem found.
  static void validate(BackupDto backup) {
    if (backup.formatVersion != BackupDto.currentFormatVersion) {
      throw InvalidBackupException(
        InvalidBackupReason.unsupportedVersion,
        'formatVersion ${backup.formatVersion}',
      );
    }
    final currency = Currency.fromCode(backup.currency);
    if (currency == null) _fail('unknown currency ${backup.currency}');

    final nameKeys = <String>{};
    final borrowerIds = <int>{};
    for (final borrower in backup.borrowers) {
      if (!borrowerIds.add(borrower.id)) {
        _fail('duplicate borrower id ${borrower.id}');
      }
      if (BorrowerValidator.validateName(borrower.name) != null) {
        _fail('invalid name of borrower ${borrower.id}');
      }
      if (!nameKeys.add(borrowerNameKey(borrower.name))) {
        _fail('duplicate name of borrower ${borrower.id}');
      }
      if (!BorrowerValidator.isNoteValid(borrower.note ?? '')) {
        _fail('note too long for borrower ${borrower.id}');
      }
    }

    final loansById = <int, LoanDto>{};
    for (final loan in backup.loans) {
      if (loansById.containsKey(loan.id)) _fail('duplicate loan id ${loan.id}');
      loansById[loan.id] = loan;
      if (!borrowerIds.contains(loan.borrowerId)) {
        _fail('unknown borrower of loan ${loan.id}');
      }
      if (LoanValidator.validateAmount(Money(loan.amountMinor), currency) !=
          null) {
        _fail('invalid amount of loan ${loan.id}');
      }
      if (LoanValidator.validatePromisedReturnDate(
            loan.promisedReturnDate,
            loan.loanDate,
          ) !=
          null) {
        _fail('promised return date before loan date of loan ${loan.id}');
      }
      if (!LoanValidator.isNoteValid(loan.note ?? '')) {
        _fail('note too long for loan ${loan.id}');
      }
    }

    final repaymentIds = <int>{};
    final repaidByLoan = <int, int>{};
    for (final repayment in backup.repayments) {
      if (!repaymentIds.add(repayment.id)) {
        _fail('duplicate repayment id ${repayment.id}');
      }
      final loan = loansById[repayment.loanId];
      if (loan == null) _fail('unknown loan of repayment ${repayment.id}');
      if (repayment.amountMinor <= 0) {
        _fail('invalid amount of repayment ${repayment.id}');
      }
      if (repayment.repaymentDate < loan.loanDate) {
        _fail('repayment ${repayment.id} before its loan date');
      }
      if (!RepaymentValidator.isNoteValid(repayment.note ?? '')) {
        _fail('note too long for repayment ${repayment.id}');
      }
      final repaid = (repaidByLoan[loan.id] ?? 0) + repayment.amountMinor;
      if (repaid > loan.amountMinor) {
        _fail('repayments exceed the amount of loan ${loan.id}');
      }
      repaidByLoan[loan.id] = repaid;
    }
  }

  static Never _fail(String message) =>
      throw InvalidBackupException(InvalidBackupReason.invalid, message);
}
