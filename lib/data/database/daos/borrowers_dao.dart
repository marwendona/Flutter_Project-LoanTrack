import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'borrowers_dao.g.dart';

@DriftAccessor(tables: [Borrowers])
class BorrowersDao extends DatabaseAccessor<AppDatabase>
    with _$BorrowersDaoMixin {
  BorrowersDao(super.attachedDatabase);

  Stream<List<BorrowerRow>> watchAll() =>
      (select(borrowers)..orderBy([(b) => OrderingTerm.asc(b.name)])).watch();

  Future<BorrowerRow?> findById(int id) =>
      (select(borrowers)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> insertBorrower(BorrowersCompanion entry) =>
      into(borrowers).insert(entry);

  /// Loans and repayments are removed by the foreign key cascade, in the same
  /// transaction (ENF-06).
  Future<int> deleteById(int id) => transaction(
    () => (delete(borrowers)..where((b) => b.id.equals(id))).go(),
  );
}
