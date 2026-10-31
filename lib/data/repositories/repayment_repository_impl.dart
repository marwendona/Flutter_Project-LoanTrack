import 'package:drift/drift.dart';

import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../../domain/models/repayment.dart';
import '../../domain/repositories/repayment_repository.dart';
import '../database/app_database.dart';
import '../database/daos/repayments_dao.dart';
import 'mappers.dart';

class RepaymentRepositoryImpl implements RepaymentRepository {
  RepaymentRepositoryImpl(this._dao);

  final RepaymentsDao _dao;

  @override
  Stream<List<Repayment>> watchByLoan(int loanId) => _dao
      .watchByLoan(loanId)
      .map((rows) => [for (final row in rows) row.toDomain()]);

  @override
  Future<int> add({
    required int loanId,
    required Money amount,
    required LocalDay repaymentDate,
    String? note,
  }) {
    return _dao.insertRepayment(
      RepaymentsCompanion.insert(
        loanId: loanId,
        amountMinor: amount.amountMinor,
        repaymentDate: repaymentDate,
        note: Value(note),
      ),
    );
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);
}
