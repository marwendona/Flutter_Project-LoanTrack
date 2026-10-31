import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> addBorrower(String name) => db.borrowersDao.insertBorrower(
    BorrowersCompanion.insert(
      name: name,
      nameKey: name.toLowerCase(),
      createdAt: LocalDay(2026, 10, 1),
    ),
  );

  Future<int> addLoan(int borrowerId, {int amountMinor = 1000, int day = 1}) =>
      db.loansDao.insertLoan(
        LoansCompanion.insert(
          borrowerId: borrowerId,
          amountMinor: amountMinor,
          loanDate: LocalDay(2026, 10, day),
        ),
      );

  Future<int> addRepayment(int loanId, {int amountMinor = 100}) =>
      db.repaymentsDao.insertRepayment(
        RepaymentsCompanion.insert(
          loanId: loanId,
          amountMinor: amountMinor,
          repaymentDate: LocalDay(2026, 10, 20),
        ),
      );

  Future<int> count(String table) async {
    final row = await db
        .customSelect('SELECT COUNT(*) AS c FROM $table')
        .getSingle();
    return row.read<int>('c');
  }

  group('schema', () {
    test('enables foreign keys', () async {
      final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(row.data.values.single, 1);
    });

    test('creates the indexes', () async {
      final rows = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
          .get();
      final names = rows.map((r) => r.read<String>('name'));
      expect(names, containsAll(['idx_loans_borrower', 'idx_repayments_loan']));
    });
  });

  group('borrowers', () {
    test('inserts and reads a borrower', () async {
      final id = await db.borrowersDao.insertBorrower(
        BorrowersCompanion.insert(
          name: 'Ali',
          nameKey: 'ali',
          phone: const Value('+216 20 000 000'),
          createdAt: LocalDay(2026, 10, 30),
        ),
      );

      final borrower = await db.borrowersDao.findById(id);
      expect(borrower, isNotNull);
      expect(borrower!.name, 'Ali');
      expect(borrower.phone, '+216 20 000 000');
      expect(borrower.note, isNull);
      expect(borrower.createdAt, LocalDay(2026, 10, 30));
    });

    test('lists borrowers by name', () async {
      await addBorrower('Sami');
      await addBorrower('Ali');
      final rows = await db.borrowersDao.watchAll().first;
      expect(rows.map((b) => b.name), ['Ali', 'Sami']);
    });

    test('rejects a duplicate name key', () async {
      await addBorrower('Ali');
      await expectLater(addBorrower('ALI'), throwsA(isA<SqliteException>()));
    });
  });

  group('loans', () {
    test('inserts and reads loans, most recent first', () async {
      final borrowerId = await addBorrower('Ali');
      await addLoan(borrowerId, amountMinor: 1250500, day: 1);
      await db.loansDao.insertLoan(
        LoansCompanion.insert(
          borrowerId: borrowerId,
          amountMinor: 500,
          loanDate: LocalDay(2026, 10, 15),
          promisedReturnDate: Value(LocalDay(2026, 12, 31)),
          note: const Value('voiture'),
        ),
      );

      final loans = await db.loansDao.watchByBorrower(borrowerId).first;
      expect(loans.map((l) => l.loanDate), [
        LocalDay(2026, 10, 15),
        LocalDay(2026, 10, 1),
      ]);
      expect(loans.first.promisedReturnDate, LocalDay(2026, 12, 31));
      expect(loans.first.note, 'voiture');
      expect(loans.last.amountMinor, 1250500);
      expect(loans.last.promisedReturnDate, isNull);
    });

    test('rejects a zero or negative amount', () async {
      final borrowerId = await addBorrower('Ali');
      await expectLater(
        addLoan(borrowerId, amountMinor: 0),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        addLoan(borrowerId, amountMinor: -1),
        throwsA(isA<SqliteException>()),
      );
    });

    test('rejects an unknown borrower', () async {
      await expectLater(addLoan(999), throwsA(isA<SqliteException>()));
    });
  });

  group('repayments', () {
    test('inserts and reads repayments', () async {
      final loanId = await addLoan(await addBorrower('Ali'));
      await addRepayment(loanId, amountMinor: 300);

      final repayments = await db.repaymentsDao.watchByLoan(loanId).first;
      expect(repayments.single.amountMinor, 300);
      expect(repayments.single.repaymentDate, LocalDay(2026, 10, 20));
    });

    test('rejects a zero amount and an unknown loan', () async {
      final loanId = await addLoan(await addBorrower('Ali'));
      await expectLater(
        addRepayment(loanId, amountMinor: 0),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(addRepayment(999), throwsA(isA<SqliteException>()));
    });
  });

  group('cascade delete', () {
    test('deleting a borrower deletes its loans and repayments only', () async {
      final ali = await addBorrower('Ali');
      final sami = await addBorrower('Sami');
      final aliLoan = await addLoan(ali);
      await addRepayment(aliLoan);
      await addRepayment(aliLoan);
      final samiLoan = await addLoan(sami);
      await addRepayment(samiLoan);

      await db.borrowersDao.deleteById(ali);

      expect(await db.borrowersDao.findById(ali), isNull);
      expect(await count('loans'), 1);
      expect(await count('repayments'), 1);
      expect(await db.loansDao.watchByBorrower(sami).first, hasLength(1));
    });

    test('deleting a loan deletes its repayments', () async {
      final borrowerId = await addBorrower('Ali');
      final loanId = await addLoan(borrowerId);
      final otherLoanId = await addLoan(borrowerId);
      await addRepayment(loanId);
      await addRepayment(otherLoanId);

      await db.loansDao.deleteById(loanId);

      expect(await db.repaymentsDao.watchByLoan(loanId).first, isEmpty);
      expect(
        await db.repaymentsDao.watchByLoan(otherLoanId).first,
        hasLength(1),
      );
    });
  });
}
