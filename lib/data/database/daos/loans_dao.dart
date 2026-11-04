import 'package:drift/drift.dart';

import '../../../core/date/local_day.dart';
import '../app_database.dart';
import '../tables.dart';

part 'loans_dao.g.dart';

/// One loan with the sum of its repayments in minor units and the date of its
/// most recent repayment (null if it has none).
typedef LoanRepaymentsRow = ({
  LoanRow loan,
  int repaidMinor,
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
    final repaid = repayments.amountMinor.sum();
    final lastRepaymentDate = repayments.repaymentDate.max();
    final query =
        select(loans).join([
            leftOuterJoin(
              repayments,
              repayments.loanId.equalsExp(loans.id),
              useColumns: false,
            ),
          ])
          ..addColumns([repaid, lastRepaymentDate])
          ..where(loans.borrowerId.equals(borrowerId))
          ..groupBy([loans.id])
          ..orderBy([
            OrderingTerm.desc(loans.loanDate),
            OrderingTerm.desc(loans.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            loan: row.readTable(loans),
            repaidMinor: row.read(repaid) ?? 0,
            lastRepaymentDate: switch (row.read(lastRepaymentDate)) {
              final int epochDay => LocalDay.fromEpochDay(epochDay),
              null => null,
            },
          ),
      ],
    );
  }

  Future<int> insertLoan(LoansCompanion entry) => into(loans).insert(entry);

  /// Repayments are removed by the foreign key cascade (RG-14).
  Future<int> deleteById(int id) =>
      transaction(() => (delete(loans)..where((l) => l.id.equals(id))).go());
}
