import '../models/borrower.dart';

abstract interface class BorrowerRepository {
  Stream<List<Borrower>> watchAll();

  /// Stores a new borrower created today and returns its id.
  Future<int> add({required String name, String? phone, String? note});

  /// Deletes the borrower with its loans and repayments (RG-03).
  Future<void> delete(int id);
}
