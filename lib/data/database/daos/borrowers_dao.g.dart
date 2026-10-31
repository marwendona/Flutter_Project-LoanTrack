// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrowers_dao.dart';

// ignore_for_file: type=lint
mixin _$BorrowersDaoMixin on DatabaseAccessor<AppDatabase> {
  $BorrowersTable get borrowers => attachedDatabase.borrowers;
  BorrowersDaoManager get managers => BorrowersDaoManager(this);
}

class BorrowersDaoManager {
  final _$BorrowersDaoMixin _db;
  BorrowersDaoManager(this._db);
  $$BorrowersTableTableManager get borrowers =>
      $$BorrowersTableTableManager(_db.attachedDatabase, _db.borrowers);
}
