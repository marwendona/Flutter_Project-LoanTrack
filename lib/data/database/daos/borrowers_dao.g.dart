// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrowers_dao.dart';

// ignore_for_file: type=lint
mixin _$BorrowersDaoMixin on DatabaseAccessor<AppDatabase> {
  $BorrowersTable get borrowers => attachedDatabase.borrowers;
  $LoansTable get loans => attachedDatabase.loans;
  $RepaymentsTable get repayments => attachedDatabase.repayments;
  BorrowersDaoManager get managers => BorrowersDaoManager(this);
}

class BorrowersDaoManager {
  final _$BorrowersDaoMixin _db;
  BorrowersDaoManager(this._db);
  $$BorrowersTableTableManager get borrowers =>
      $$BorrowersTableTableManager(_db.attachedDatabase, _db.borrowers);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db.attachedDatabase, _db.loans);
  $$RepaymentsTableTableManager get repayments =>
      $$RepaymentsTableTableManager(_db.attachedDatabase, _db.repayments);
}
