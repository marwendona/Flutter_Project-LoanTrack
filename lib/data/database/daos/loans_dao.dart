import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'loans_dao.g.dart';

@DriftAccessor(tables: [Loans])
class LoansDao extends DatabaseAccessor<AppDatabase> with _$LoansDaoMixin {
  LoansDao(super.attachedDatabase);

  /// Most recent first (RG-15).
  Stream<List<LoanRow>> watchByBorrower(int borrowerId) =>
      (select(loans)
            ..where((l) => l.borrowerId.equals(borrowerId))
            ..orderBy([
              (l) => OrderingTerm.desc(l.loanDate),
              (l) => OrderingTerm.desc(l.id),
            ]))
          .watch();

  Future<int> insertLoan(LoansCompanion entry) => into(loans).insert(entry);

  /// Repayments are removed by the foreign key cascade (RG-14).
  Future<int> deleteById(int id) =>
      transaction(() => (delete(loans)..where((l) => l.id.equals(id))).go());
}
