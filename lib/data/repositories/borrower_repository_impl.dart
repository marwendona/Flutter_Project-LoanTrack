import 'package:drift/drift.dart';

import '../../core/date/local_day.dart';
import '../../domain/models/borrower.dart';
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
