import 'package:drift/drift.dart';

import 'converters.dart';

// Row classes are suffixed with "Row": they never leave lib/data and are
// mapped to the domain models (Borrower, Loan, Repayment).
//
// `check(column...)` referencing its own getter is the Drift idiom for CHECK
// constraints, hence the ignored recursive_getters lint.
// ignore_for_file: recursive_getters

@DataClassName('BorrowerRow')
class Borrowers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// Normalized name, unique to forbid duplicates (RG-02).
  TextColumn get nameKey => text().unique()();
  TextColumn get phone => text().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get createdAt => integer().map(const LocalDayConverter())();
}

@DataClassName('LoanRow')
@TableIndex(name: 'idx_loans_borrower', columns: {#borrowerId})
class Loans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get borrowerId =>
      integer().references(Borrowers, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountMinor =>
      integer().check(amountMinor.isBiggerThanValue(0))();
  IntColumn get loanDate => integer().map(const LocalDayConverter())();
  IntColumn get promisedReturnDate =>
      integer().nullable().map(const LocalDayConverter())();
  TextColumn get note => text().nullable()();
}

@DataClassName('RepaymentRow')
@TableIndex(name: 'idx_repayments_loan', columns: {#loanId})
class Repayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get loanId =>
      integer().references(Loans, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountMinor =>
      integer().check(amountMinor.isBiggerThanValue(0))();
  IntColumn get repaymentDate => integer().map(const LocalDayConverter())();
  TextColumn get note => text().nullable()();
}
