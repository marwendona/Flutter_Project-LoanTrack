import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../models/repayment.dart';

/// The repayment to update does not exist (anymore).
class RepaymentNotFoundException implements Exception {
  const RepaymentNotFoundException(this.id);

  final int id;

  @override
  String toString() => 'RepaymentNotFoundException($id)';
}

abstract interface class RepaymentRepository {
  Stream<List<Repayment>> watchByLoan(int loanId);

  /// Stores a new repayment and returns its id.
  Future<int> add({
    required int loanId,
    required Money amount,
    required LocalDay repaymentDate,
    String? note,
  });

  /// Replaces the amount, date and note of an existing repayment (RG-19).
  /// Throws [RepaymentNotFoundException] if it does not exist.
  Future<void> update(Repayment repayment);

  Future<void> delete(int id);
}
