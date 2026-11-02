import '../models/borrower.dart';
import '../models/borrower_summary.dart';

abstract interface class BorrowerRepository {
  Stream<List<Borrower>> watchAll();

  /// Every borrower (by name) with the balance of each of its loans,
  /// re-emitted whenever a borrower, loan or repayment changes.
  Stream<List<BorrowerWithLoans>> watchAllWithLoanBalances();

  /// Stores a new borrower created today and returns its id.
  Future<int> add({required String name, String? phone, String? note});

  /// Deletes the borrower with its loans and repayments (RG-03).
  Future<void> delete(int id);
}
