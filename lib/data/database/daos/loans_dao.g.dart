// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loans_dao.dart';

// ignore_for_file: type=lint
mixin _$LoansDaoMixin on DatabaseAccessor<AppDatabase> {
  $BorrowersTable get borrowers => attachedDatabase.borrowers;
  $LoansTable get loans => attachedDatabase.loans;
  LoansDaoManager get managers => LoansDaoManager(this);
}

class LoansDaoManager {
  final _$LoansDaoMixin _db;
  LoansDaoManager(this._db);
  $$BorrowersTableTableManager get borrowers =>
      $$BorrowersTableTableManager(_db.attachedDatabase, _db.borrowers);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db.attachedDatabase, _db.loans);
}
