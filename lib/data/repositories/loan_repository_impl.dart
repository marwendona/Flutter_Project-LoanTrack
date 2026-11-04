import 'package:drift/drift.dart';

import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../../domain/models/loan.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/repositories/loan_repository.dart';
import '../database/app_database.dart';
import '../database/daos/loans_dao.dart';
import 'mappers.dart';

class LoanRepositoryImpl implements LoanRepository {
  LoanRepositoryImpl(this._dao);

  final LoansDao _dao;

  @override
  Stream<List<Loan>> watchByBorrower(int borrowerId) => _dao
      .watchByBorrower(borrowerId)
      .map((rows) => [for (final row in rows) row.toDomain()]);

  @override
  Stream<List<LoanSummary>> watchSummariesByBorrower(int borrowerId) => _dao
      .watchWithRepaymentsByBorrower(borrowerId)
      .map((rows) => [for (final row in rows) _toSummary(row)]);

  @override
  Future<LoanSummary?> getSummaryById(int id) async {
    final row = await _dao.getWithRepaymentsById(id);
    return row == null ? null : _toSummary(row);
  }

  static LoanSummary _toSummary(LoanRepaymentsRow row) => LoanSummary(
    loan: row.loan.toDomain(),
    repaid: Money(row.repaidMinor),
    firstRepaymentDate: row.firstRepaymentDate,
    lastRepaymentDate: row.lastRepaymentDate,
  );

  @override
  Future<int> add({
    required int borrowerId,
    required Money amount,
    required LocalDay loanDate,
    LocalDay? promisedReturnDate,
    String? note,
  }) {
    return _dao.insertLoan(
      LoansCompanion.insert(
        borrowerId: borrowerId,
        amountMinor: amount.amountMinor,
        loanDate: loanDate,
        promisedReturnDate: Value(promisedReturnDate),
        note: Value(note),
      ),
    );
  }

  @override
  Future<void> update(Loan loan) async {
    final updated = await _dao.updateLoan(
      LoanRow(
        id: loan.id,
        borrowerId: loan.borrowerId,
        amountMinor: loan.amount.amountMinor,
        loanDate: loan.loanDate,
        promisedReturnDate: loan.promisedReturnDate,
        note: loan.note,
      ),
    );
    if (!updated) throw LoanNotFoundException(loan.id);
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);
}
