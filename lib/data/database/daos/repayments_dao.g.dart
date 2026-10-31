// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayments_dao.dart';

// ignore_for_file: type=lint
mixin _$RepaymentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BorrowersTable get borrowers => attachedDatabase.borrowers;
  $LoansTable get loans => attachedDatabase.loans;
  $RepaymentsTable get repayments => attachedDatabase.repayments;
  RepaymentsDaoManager get managers => RepaymentsDaoManager(this);
}

class RepaymentsDaoManager {
  final _$RepaymentsDaoMixin _db;
  RepaymentsDaoManager(this._db);
  $$BorrowersTableTableManager get borrowers =>
      $$BorrowersTableTableManager(_db.attachedDatabase, _db.borrowers);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db.attachedDatabase, _db.loans);
  $$RepaymentsTableTableManager get repayments =>
      $$RepaymentsTableTableManager(_db.attachedDatabase, _db.repayments);
}
