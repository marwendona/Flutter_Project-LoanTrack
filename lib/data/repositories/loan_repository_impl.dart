import 'package:drift/drift.dart';

import '../../core/date/local_day.dart';
import '../../core/money/money.dart';
import '../../domain/models/loan.dart';
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
  Future<void> delete(int id) => _dao.deleteById(id);
}
