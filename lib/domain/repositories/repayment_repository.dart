import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../models/repayment.dart';

abstract interface class RepaymentRepository {
  Stream<List<Repayment>> watchByLoan(int loanId);

  /// Stores a new repayment and returns its id.
  Future<int> add({
    required int loanId,
    required Money amount,
    required LocalDay repaymentDate,
    String? note,
  });

  Future<void> delete(int id);
}
