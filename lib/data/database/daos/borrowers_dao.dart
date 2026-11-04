import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'borrowers_dao.g.dart';

/// One borrower with one of its loans (null if it has none) and the sum of
/// that loan's repayments in minor units.
typedef BorrowerLoanBalanceRow = ({
  BorrowerRow borrower,
  LoanRow? loan,
  int repaidMinor,
});

@DriftAccessor(tables: [Borrowers, Loans, Repayments])
class BorrowersDao extends DatabaseAccessor<AppDatabase>
    with _$BorrowersDaoMixin {
  BorrowersDao(super.attachedDatabase);

  Stream<List<BorrowerRow>> watchAll() =>
      (select(borrowers)..orderBy([(b) => OrderingTerm.asc(b.name)])).watch();

  /// One row per (borrower, loan), borrowers by name, then loans by id.
  /// Repaid amounts are aggregated in SQL, never stored (RG-21).
  Stream<List<BorrowerLoanBalanceRow>> watchWithLoanBalances() {
    final repaid = repayments.amountMinor.sum();
    final query =
        select(borrowers).join([
            leftOuterJoin(loans, loans.borrowerId.equalsExp(borrowers.id)),
            leftOuterJoin(
              repayments,
              repayments.loanId.equalsExp(loans.id),
              useColumns: false,
            ),
          ])
          ..addColumns([repaid])
          ..groupBy([borrowers.id, loans.id])
          ..orderBy([
            OrderingTerm.asc(borrowers.name),
            OrderingTerm.asc(borrowers.id),
            OrderingTerm.asc(loans.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            borrower: row.readTable(borrowers),
            loan: row.readTableOrNull(loans),
            repaidMinor: row.read(repaid) ?? 0,
          ),
      ],
    );
  }

  Stream<BorrowerRow?> watchById(int id) =>
      (select(borrowers)..where((b) => b.id.equals(id))).watchSingleOrNull();

  Future<BorrowerRow?> findById(int id) =>
      (select(borrowers)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> insertBorrower(BorrowersCompanion entry) =>
      into(borrowers).insert(entry);

  /// Inserts [entry] unless a borrower already has its name key (RG-02).
  /// Returns the new id, or null if the name key is taken.
  Future<int?> insertBorrowerIfNameKeyFree(BorrowersCompanion entry) =>
      transaction(() async {
        final existing =
            await (select(borrowers)
                  ..where((b) => b.nameKey.equals(entry.nameKey.value))
                  ..limit(1))
                .getSingleOrNull();
        if (existing != null) return null;
        return into(borrowers).insert(entry);
      });

  /// Updates [entry] unless another borrower already has its name key (RG-02).
  /// Returns true if updated, false if the name key is taken by another borrower.
  Future<bool> updateBorrowerIfNameKeyFree(BorrowersCompanion entry) =>
      transaction(() async {
        final existing =
            await (select(borrowers)
                  ..where(
                    (b) =>
                        b.nameKey.equals(entry.nameKey.value) &
                        b.id.equals(entry.id.value).not(),
                  )
                  ..limit(1))
                .getSingleOrNull();
        if (existing != null) return false;
        final rowsUpdated = await update(borrowers).write(entry);
        return rowsUpdated > 0;
      });

  /// Loans and repayments are removed by the foreign key cascade, in the same
  /// transaction (ENF-06).
  Future<int> deleteById(int id) => transaction(
    () => (delete(borrowers)..where((b) => b.id.equals(id))).go(),
  );
}
