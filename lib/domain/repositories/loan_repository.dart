import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../models/loan.dart';

abstract interface class LoanRepository {
  Stream<List<Loan>> watchByBorrower(int borrowerId);

  /// Stores a new loan and returns its id.
  Future<int> add({
    required int borrowerId,
    required Money amount,
    required LocalDay loanDate,
    LocalDay? promisedReturnDate,
    String? note,
  });

  /// Deletes the loan with its repayments (RG-14).
  Future<void> delete(int id);
}
