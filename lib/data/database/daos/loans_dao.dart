import 'package:drift/drift.dart';

import '../../../core/date/local_day.dart';
import '../app_database.dart';
import '../tables.dart';

part 'loans_dao.g.dart';

/// One loan with the sum of its repayments in minor units and the dates of its
/// earliest and most recent repayments (null if it has none).
typedef LoanRepaymentsRow = ({
  LoanRow loan,
  int repaidMinor,
  LocalDay? firstRepaymentDate,
  LocalDay? lastRepaymentDate,
});

@DriftAccessor(tables: [Loans, Repayments])
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

  /// The borrower's loans, most recent first (RG-15), with their repayments
  /// aggregated in SQL, never stored (RG-21, RG-22).
  Stream<List<LoanRepaymentsRow>> watchWithRepaymentsByBorrower(
    int borrowerId,
  ) {
    final query = _withRepayments()
      ..where(loans.borrowerId.equals(borrowerId))
      ..orderBy([
        OrderingTerm.desc(loans.loanDate),
        OrderingTerm.desc(loans.id),
      ]);
    return query.watch().map((rows) => [for (final row in rows) _read(row)]);
  }

  /// The loan [id] with its repayments aggregated, null if it does not exist.
  Future<LoanRepaymentsRow?> getWithRepaymentsById(int id) async {
    final query = _withRepayments()..where(loans.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _read(row);
  }

  // Aggregates computed in SQL, never stored (RG-21, RG-22).
  late final _repaid = repayments.amountMinor.sum();
  late final _firstRepaymentDate = repayments.repaymentDate.min();
  late final _lastRepaymentDate = repayments.repaymentDate.max();

  JoinedSelectStatement<HasResultSet, dynamic> _withRepayments() =>
      select(loans).join([
          leftOuterJoin(
            repayments,
            repayments.loanId.equalsExp(loans.id),
            useColumns: false,
          ),
        ])
        ..addColumns([_repaid, _firstRepaymentDate, _lastRepaymentDate])
        ..groupBy([loans.id]);

  LoanRepaymentsRow _read(TypedResult row) => (
    loan: row.readTable(loans),
    repaidMinor: row.read(_repaid) ?? 0,
    firstRepaymentDate: _toLocalDay(row.read(_firstRepaymentDate)),
    lastRepaymentDate: _toLocalDay(row.read(_lastRepaymentDate)),
  );

  static LocalDay? _toLocalDay(int? epochDay) =>
      epochDay == null ? null : LocalDay.fromEpochDay(epochDay);

  Future<int> insertLoan(LoansCompanion entry) => into(loans).insert(entry);

  /// Returns true if a loan was updated.
  Future<bool> updateLoan(LoanRow row) => update(loans).replace(row);

  /// Repayments are removed by the foreign key cascade (RG-14).
  Future<int> deleteById(int id) =>
      transaction(() => (delete(loans)..where((l) => l.id.equals(id))).go());
}
