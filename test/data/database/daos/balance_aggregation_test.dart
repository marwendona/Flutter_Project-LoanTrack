import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/database/app_database.dart';
import 'package:loantrack/data/database/daos/borrowers_dao.dart';
import 'package:loantrack/data/database/daos/loans_dao.dart';
import 'package:loantrack/data/repositories/mappers.dart';
import 'package:loantrack/domain/models/loan_balance.dart';
import 'package:loantrack/domain/services/borrower_summary_calculator.dart';

/// Integration tests of the repaid / remaining due aggregations computed in SQL
/// (RG-21, RG-22, RG-30), on an in-memory Drift database (US-3.4).
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> addBorrower(String name) => db.borrowersDao.insertBorrower(
    BorrowersCompanion.insert(
      name: name,
      nameKey: name.toLowerCase(),
      createdAt: LocalDay(2026, 9, 1),
    ),
  );

  Future<int> addLoan(int borrowerId, int amountMinor, {int day = 1}) =>
      db.loansDao.insertLoan(
        LoansCompanion.insert(
          borrowerId: borrowerId,
          amountMinor: amountMinor,
          loanDate: LocalDay(2026, 9, day),
        ),
      );

  Future<int> addRepayment(int loanId, int amountMinor, LocalDay date) =>
      db.repaymentsDao.insertRepayment(
        RepaymentsCompanion.insert(
          loanId: loanId,
          amountMinor: amountMinor,
          repaymentDate: date,
        ),
      );

  /// (amount, repaid, remaining) of a loan row, in minor units.
  (int, int, int) loanBalance(LoanRepaymentsRow row) => (
    row.loan.amountMinor,
    row.repaidMinor,
    row.loan.amountMinor - row.repaidMinor,
  );

  /// Borrower name → (total lent, total repaid, remaining due), computed by
  /// the domain calculator from the DAO rows, as the screens do (RG-30).
  Map<String, (int, int, int)> borrowerTotals(
    List<BorrowerLoanBalanceRow> rows,
  ) {
    final loansByBorrower = <BorrowerRow, List<LoanBalance>>{};
    for (final row in rows) {
      final loans = loansByBorrower.putIfAbsent(row.borrower, () => []);
      final loan = row.loan;
      if (loan != null) {
        loans.add(
          LoanBalance(
            amount: Money(loan.amountMinor),
            repaid: Money(row.repaidMinor),
          ),
        );
      }
    }
    return {
      for (final MapEntry(key: borrower, value: loans)
          in loansByBorrower.entries)
        borrower.name: () {
          final summary = BorrowerSummaryCalculator.summarize(
            borrower.toDomain(),
            loans,
            LocalDay(2026, 11, 4),
          );
          return (
            summary.totalLent.amountMinor,
            summary.totalRepaid.amountMinor,
            summary.remaining.amountMinor,
          );
        }(),
    };
  }

  group('a loan without repayment', () {
    late int borrowerId;
    late int loanId;

    setUp(() async {
      borrowerId = await addBorrower('Ali');
      loanId = await addLoan(borrowerId, 5000);
    });

    test('has repaid 0, remaining = amount and no repayment dates', () async {
      final row = (await db.loansDao.getWithRepaymentsById(loanId))!;

      expect(loanBalance(row), (5000, 0, 5000));
      expect(row.firstRepaymentDate, isNull);
      expect(row.lastRepaymentDate, isNull);
    });

    test('is returned by every aggregated query', () async {
      final byBorrower = await db.loansDao
          .watchWithRepaymentsByBorrower(borrowerId)
          .first;
      final byId = await db.loansDao.watchWithRepaymentsById(loanId).first;
      final balances = await db.borrowersDao.watchWithLoanBalances().first;

      expect(byBorrower.map(loanBalance), [(5000, 0, 5000)]);
      expect(loanBalance(byId!), (5000, 0, 5000));
      expect(balances.map((r) => (r.loan?.id, r.repaidMinor)), [(loanId, 0)]);
    });
  });

  group('several borrowers, loans and repayments', () {
    late int ali;
    late int sami;
    late int aliPartial;
    late int aliUnpaid;
    late int aliRepaid;
    late int samiLoan;

    setUp(() async {
      ali = await addBorrower('Ali');
      sami = await addBorrower('Sami');
      await addBorrower('Zied');
      aliPartial = await addLoan(ali, 5000, day: 1);
      aliUnpaid = await addLoan(ali, 2000, day: 2);
      aliRepaid = await addLoan(ali, 1000, day: 3);
      samiLoan = await addLoan(sami, 2500, day: 4);
      await addRepayment(aliPartial, 1000, LocalDay(2026, 9, 20));
      await addRepayment(aliPartial, 500, LocalDay(2026, 9, 10));
      await addRepayment(aliPartial, 1500, LocalDay(2026, 10, 5));
      await addRepayment(aliRepaid, 400, LocalDay(2026, 9, 15));
      await addRepayment(aliRepaid, 600, LocalDay(2026, 9, 25));
      await addRepayment(samiLoan, 500, LocalDay(2026, 10, 1));
    });

    test('per loan: sums only the loan own repayments (RG-21)', () async {
      final rows = await db.loansDao.watchWithRepaymentsByBorrower(ali).first;

      // Most recent loan first (RG-15).
      expect(rows.map((r) => r.loan.id), [aliRepaid, aliUnpaid, aliPartial]);
      expect(rows.map(loanBalance), [
        (1000, 1000, 0),
        (2000, 0, 2000),
        (5000, 3000, 2000),
      ]);
    });

    test('per loan: earliest and most recent repayment dates', () async {
      final partial = (await db.loansDao.getWithRepaymentsById(aliPartial))!;
      final repaid = (await db.loansDao.getWithRepaymentsById(aliRepaid))!;

      expect(partial.firstRepaymentDate, LocalDay(2026, 9, 10));
      expect(partial.lastRepaymentDate, LocalDay(2026, 10, 5));
      // Effective repayment date of a fully repaid loan (RG-22).
      expect(repaid.lastRepaymentDate, LocalDay(2026, 9, 25));
    });

    test('per loan: the other borrower loans are not mixed in', () async {
      final rows = await db.loansDao.watchWithRepaymentsByBorrower(sami).first;

      expect(rows.map(loanBalance), [(2500, 500, 2000)]);
      expect(await db.loansDao.getWithRepaymentsById(samiLoan + 100), isNull);
    });

    test('per borrower: one row per loan without repayment '
        'duplication', () async {
      final rows = await db.borrowersDao.watchWithLoanBalances().first;

      expect(rows.map((r) => (r.borrower.name, r.loan?.id, r.repaidMinor)), [
        ('Ali', aliPartial, 3000),
        ('Ali', aliUnpaid, 0),
        ('Ali', aliRepaid, 1000),
        ('Sami', samiLoan, 500),
        ('Zied', null, 0),
      ]);
    });

    test('per borrower: total lent, repaid and remaining due (RG-30), '
        'zero for a borrower without loan', () async {
      final rows = await db.borrowersDao.watchWithLoanBalances().first;

      expect(borrowerTotals(rows), {
        'Ali': (8000, 4000, 4000),
        'Sami': (2500, 500, 2000),
        'Zied': (0, 0, 0),
      });
    });

    test('per borrower: totals follow repayment changes and loan '
        'deletion', () async {
      final totals = db.borrowersDao.watchWithLoanBalances().map(
        (rows) => borrowerTotals(rows)['Ali'],
      );
      final expectation = expectLater(
        totals,
        emitsInOrder([
          (8000, 4000, 4000),
          // A first repayment of the unpaid loan.
          (8000, 4700, 3300),
          // That repayment corrected to the whole remaining due.
          (8000, 6000, 2000),
          // That repayment deleted: back to a loan without repayment.
          (8000, 4000, 4000),
          // The partially repaid loan deleted with its repayments (RG-14).
          (3000, 1000, 2000),
        ]),
      );
      await totals.first;

      final repaymentId = await addRepayment(
        aliUnpaid,
        700,
        LocalDay(2026, 10, 10),
      );
      await Future<void>.delayed(Duration.zero);
      await db.repaymentsDao.updateRepayment(
        RepaymentRow(
          id: repaymentId,
          loanId: aliUnpaid,
          amountMinor: 2000,
          repaymentDate: LocalDay(2026, 10, 10),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      await db.repaymentsDao.deleteById(repaymentId);
      await Future<void>.delayed(Duration.zero);
      await db.loansDao.deleteById(aliPartial);

      await expectation;
    });

    test('per loan: remaining due follows repayment changes', () async {
      final remaining = db.loansDao
          .watchWithRepaymentsById(aliUnpaid)
          .map((row) => row == null ? null : loanBalance(row));
      final expectation = expectLater(
        remaining,
        emitsInOrder([(2000, 0, 2000), (2000, 2000, 0), (2000, 0, 2000), null]),
      );
      await remaining.first;

      final repaymentId = await addRepayment(
        aliUnpaid,
        2000,
        LocalDay(2026, 10, 10),
      );
      await Future<void>.delayed(Duration.zero);
      await db.repaymentsDao.deleteById(repaymentId);
      await Future<void>.delayed(Duration.zero);
      await db.loansDao.deleteById(aliUnpaid);

      await expectation;
    });
  });

  test('sums amounts beyond 32-bit integers without loss', () async {
    // 5 000 000 TND lent, i.e. 5 000 000 000 millimes (> 2^31).
    final borrowerId = await addBorrower('Ali');
    final loanId = await addLoan(borrowerId, 5000000000);
    await addRepayment(loanId, 3000000000, LocalDay(2026, 9, 10));
    await addRepayment(loanId, 1500000001, LocalDay(2026, 9, 20));

    final row = (await db.loansDao.getWithRepaymentsById(loanId))!;
    final balances = await db.borrowersDao.watchWithLoanBalances().first;

    expect(loanBalance(row), (5000000000, 4500000001, 499999999));
    expect(borrowerTotals(balances), {
      'Ali': (5000000000, 4500000001, 499999999),
    });
  });
}
