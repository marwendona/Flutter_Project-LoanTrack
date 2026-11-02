import 'package:drift/drift.dart';

import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../../domain/models/borrower.dart';
import '../../domain/models/borrower_summary.dart';
import '../../domain/models/loan_balance.dart';
import '../../domain/repositories/borrower_repository.dart';
import '../../domain/services/borrower_name_key.dart';
import '../database/app_database.dart';
import '../database/daos/borrowers_dao.dart';
import 'mappers.dart';

class BorrowerRepositoryImpl implements BorrowerRepository {
  BorrowerRepositoryImpl(this._dao);

  final BorrowersDao _dao;

  @override
  Stream<List<Borrower>> watchAll() =>
      _dao.watchAll().map((rows) => [for (final row in rows) row.toDomain()]);

  @override
  Stream<List<BorrowerWithLoans>> watchAllWithLoanBalances() =>
      _dao.watchWithLoanBalances().map(_groupByBorrower);

  /// Rows arrive sorted by borrower: group them keeping that order.
  static List<BorrowerWithLoans> _groupByBorrower(
    List<BorrowerLoanBalanceRow> rows,
  ) {
    final result = <BorrowerWithLoans>[];
    for (final row in rows) {
      if (result.isEmpty || result.last.borrower.id != row.borrower.id) {
        result.add((borrower: row.borrower.toDomain(), loans: <LoanBalance>[]));
      }
      final loan = row.loan;
      if (loan != null) {
        result.last.loans.add(
          LoanBalance(
            amount: Money(loan.amountMinor),
            repaid: Money(row.repaidMinor),
            promisedReturnDate: loan.promisedReturnDate,
          ),
        );
      }
    }
    return result;
  }

  @override
  Future<int> add({required String name, String? phone, String? note}) {
    return _dao.insertBorrower(
      BorrowersCompanion.insert(
        name: name,
        nameKey: borrowerNameKey(name),
        phone: Value(phone),
        note: Value(note),
        createdAt: LocalDay.today(),
      ),
    );
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);
}
