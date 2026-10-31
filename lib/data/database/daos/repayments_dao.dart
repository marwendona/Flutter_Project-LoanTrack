import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'repayments_dao.g.dart';

@DriftAccessor(tables: [Repayments])
class RepaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$RepaymentsDaoMixin {
  RepaymentsDao(super.attachedDatabase);

  /// Most recent first.
  Stream<List<RepaymentRow>> watchByLoan(int loanId) =>
      (select(repayments)
            ..where((r) => r.loanId.equals(loanId))
            ..orderBy([
              (r) => OrderingTerm.desc(r.repaymentDate),
              (r) => OrderingTerm.desc(r.id),
            ]))
          .watch();

  Future<int> insertRepayment(RepaymentsCompanion entry) =>
      into(repayments).insert(entry);

  Future<int> deleteById(int id) =>
      (delete(repayments)..where((r) => r.id.equals(id))).go();
}
