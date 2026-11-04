import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../models/loan.dart';
import '../models/loan_summary.dart';

/// The loan to update does not exist anymore.
class LoanNotFoundException implements Exception {
  const LoanNotFoundException(this.id);

  final int id;

  @override
  String toString() => 'LoanNotFoundException($id)';
}

abstract interface class LoanRepository {
  Stream<List<Loan>> watchByBorrower(int borrowerId);

  /// Whether at least one loan exists, whatever its borrower (RG-41).
  Future<bool> hasAny();

  /// Same as [hasAny], re-emitted whenever a loan is added or deleted.
  Stream<bool> watchHasAny();

  /// The borrower's loans with their repaid amount and last repayment date,
  /// most recent loan first (RG-15), re-emitted whenever a loan or repayment
  /// changes.
  Stream<List<LoanSummary>> watchSummariesByBorrower(int borrowerId);

  /// Stores a new loan and returns its id.
  Future<int> add({
    required int borrowerId,
    required Money amount,
    required LocalDay loanDate,
    LocalDay? promisedReturnDate,
    String? note,
  });

  /// The loan with its repaid amount and repayment dates, null if it does not
  /// exist.
  Future<LoanSummary?> getSummaryById(int id);

  /// Same as [getSummaryById], re-emitted whenever the loan or one of its
  /// repayments changes.
  Stream<LoanSummary?> watchSummaryById(int id);

  /// Updates the amount, dates and note of an existing loan; throws
  /// [LoanNotFoundException] if it does not exist.
  Future<void> update(Loan loan);

  /// Deletes the loan with its repayments (RG-14).
  Future<void> delete(int id);
}
