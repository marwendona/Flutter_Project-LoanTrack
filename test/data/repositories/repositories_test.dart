import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/database/app_database.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_balance.dart';
import 'package:loantrack/domain/models/repayment.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/domain/repositories/repayment_repository.dart';
import 'package:loantrack/domain/services/borrower_validator.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final db = AppDatabase(NativeDatabase.memory());
          ref.onDispose(db.close);
          return db;
        }),
      ],
    );
  });
  tearDown(() => container.dispose());

  test('repositories map rows to domain models', () async {
    final borrowers = container.read(borrowerRepositoryProvider);
    final loans = container.read(loanRepositoryProvider);
    final repayments = container.read(repaymentRepositoryProvider);

    final borrowerId = await withClock(
      Clock.fixed(DateTime(2026, 10, 30, 22)),
      () => borrowers.add(name: ' Ali ', phone: '20000000'),
    );
    final loanId = await loans.add(
      borrowerId: borrowerId,
      amount: const Money(1250500),
      loanDate: LocalDay(2026, 10, 1),
      promisedReturnDate: LocalDay(2026, 12, 31),
    );
    final repaymentId = await repayments.add(
      loanId: loanId,
      amount: const Money(250500),
      repaymentDate: LocalDay(2026, 10, 20),
      note: 'espèces',
    );

    expect(await borrowers.watchAll().first, [
      Borrower(
        id: borrowerId,
        name: 'Ali',
        phone: '20000000',
        createdAt: LocalDay(2026, 10, 30),
      ),
    ]);
    expect(await loans.watchByBorrower(borrowerId).first, [
      Loan(
        id: loanId,
        borrowerId: borrowerId,
        amount: const Money(1250500),
        loanDate: LocalDay(2026, 10, 1),
        promisedReturnDate: LocalDay(2026, 12, 31),
      ),
    ]);
    expect(await repayments.watchByLoan(loanId).first, [
      Repayment(
        id: repaymentId,
        loanId: loanId,
        amount: const Money(250500),
        repaymentDate: LocalDay(2026, 10, 20),
        note: 'espèces',
      ),
    ]);
  });

  test('add trims values and stores blank optional values as null', () async {
    final borrowers = container.read(borrowerRepositoryProvider);
    final id = await borrowers.add(name: '  Sami ', phone: '   ', note: ' x ');

    final stored = (await borrowers.watchAll().first).single;
    expect(stored.id, id);
    expect(stored.name, 'Sami');
    expect(stored.phone, isNull);
    expect(stored.note, 'x');
  });

  test(
    'add refuses a duplicate name ignoring case and spaces (RG-02)',
    () async {
      final borrowers = container.read(borrowerRepositoryProvider);
      await borrowers.add(name: 'Ali');

      await expectLater(
        borrowers.add(name: '  aLI '),
        throwsA(isA<DuplicateBorrowerNameException>()),
      );
      expect(await borrowers.watchAll().first, hasLength(1));
    },
  );

  test('groups loan balances by borrower', () async {
    final borrowers = container.read(borrowerRepositoryProvider);
    final loans = container.read(loanRepositoryProvider);
    final repayments = container.read(repaymentRepositoryProvider);
    final ali = await borrowers.add(name: 'Ali');
    await borrowers.add(name: 'Sami');
    final loanId = await loans.add(
      borrowerId: ali,
      amount: const Money(5000),
      loanDate: LocalDay(2026, 10, 1),
      promisedReturnDate: LocalDay(2026, 10, 31),
    );
    await loans.add(
      borrowerId: ali,
      amount: const Money(2000),
      loanDate: LocalDay(2026, 10, 2),
    );
    await repayments.add(
      loanId: loanId,
      amount: const Money(1500),
      repaymentDate: LocalDay(2026, 10, 20),
    );

    final entries = await borrowers.watchAllWithLoanBalances().first;

    expect(entries.map((e) => e.borrower.name), ['Ali', 'Sami']);
    expect(entries.first.loans, [
      LoanBalance(
        amount: const Money(5000),
        repaid: const Money(1500),
        promisedReturnDate: LocalDay(2026, 10, 31),
      ),
      const LoanBalance(amount: Money(2000), repaid: Money.zero),
    ]);
    expect(entries.last.loans, isEmpty);
  });

  test('watchById emits the borrower, then null once deleted', () async {
    final borrowers = container.read(borrowerRepositoryProvider);
    final id = await borrowers.add(name: 'Ali', note: 'voisin');

    expect((await borrowers.watchById(id).first)?.note, 'voisin');
    await borrowers.delete(id);
    expect(await borrowers.watchById(id).first, isNull);
  });

  test(
    'loan summaries aggregate repayments, most recent loan first (RG-15)',
    () async {
      final borrowers = container.read(borrowerRepositoryProvider);
      final loans = container.read(loanRepositoryProvider);
      final repayments = container.read(repaymentRepositoryProvider);
      final ali = await borrowers.add(name: 'Ali');
      final sami = await borrowers.add(name: 'Sami');
      final older = await loans.add(
        borrowerId: ali,
        amount: const Money(5000),
        loanDate: LocalDay(2026, 9, 1),
      );
      final newer = await loans.add(
        borrowerId: ali,
        amount: const Money(2000),
        loanDate: LocalDay(2026, 10, 1),
      );
      await loans.add(
        borrowerId: sami,
        amount: const Money(9000),
        loanDate: LocalDay(2026, 10, 1),
      );
      await repayments.add(
        loanId: older,
        amount: const Money(1000),
        repaymentDate: LocalDay(2026, 10, 20),
      );
      await repayments.add(
        loanId: older,
        amount: const Money(500),
        repaymentDate: LocalDay(2026, 9, 15),
      );

      final summaries = await loans.watchSummariesByBorrower(ali).first;

      expect(summaries.map((s) => s.loan.id), [newer, older]);
      expect(summaries.first.repaid, Money.zero);
      expect(summaries.first.firstRepaymentDate, isNull);
      expect(summaries.first.lastRepaymentDate, isNull);
      expect(summaries.last.repaid, const Money(1500));
      expect(summaries.last.remaining, const Money(3500));
      expect(summaries.last.firstRepaymentDate, LocalDay(2026, 9, 15));
      expect(summaries.last.lastRepaymentDate, LocalDay(2026, 10, 20));
    },
  );

  test('adding a repayment updates the loan summaries and balances at once '
      '(US-3.1)', () async {
    final borrowers = container.read(borrowerRepositoryProvider);
    final loans = container.read(loanRepositoryProvider);
    final repayments = container.read(repaymentRepositoryProvider);
    final ali = await borrowers.add(name: 'Ali');
    final loanId = await loans.add(
      borrowerId: ali,
      amount: const Money(5000),
      loanDate: LocalDay(2026, 10, 1),
    );

    final summaries = loans.watchSummariesByBorrower(ali);
    final balances = borrowers.watchAllWithLoanBalances();
    final remainingDues = expectLater(
      summaries.map((list) => list.single.remaining),
      emitsInOrder([const Money(5000), const Money(3000), Money.zero]),
    );
    final repaidTotals = expectLater(
      balances.map((entries) => entries.single.loans.single.repaid),
      emitsInOrder([Money.zero, const Money(2000), const Money(5000)]),
    );
    // Lets both streams emit their initial value before the changes.
    await summaries.first;
    await balances.first;

    await repayments.add(
      loanId: loanId,
      amount: const Money(2000),
      repaymentDate: LocalDay(2026, 10, 10),
    );
    await Future<void>.delayed(Duration.zero);
    await repayments.add(
      loanId: loanId,
      amount: const Money(3000),
      repaymentDate: LocalDay(2026, 10, 20),
    );

    await remainingDues;
    await repaidTotals;
  });

  group('loan modification and deletion (US-2.4)', () {
    late int borrowerId;
    late int loanId;

    setUp(() async {
      borrowerId = await container
          .read(borrowerRepositoryProvider)
          .add(name: 'Ali');
      loanId = await container
          .read(loanRepositoryProvider)
          .add(
            borrowerId: borrowerId,
            amount: const Money(5000),
            loanDate: LocalDay(2026, 9, 1),
            note: 'voiture',
          );
      final repayments = container.read(repaymentRepositoryProvider);
      await repayments.add(
        loanId: loanId,
        amount: const Money(1000),
        repaymentDate: LocalDay(2026, 9, 20),
      );
      await repayments.add(
        loanId: loanId,
        amount: const Money(500),
        repaymentDate: LocalDay(2026, 9, 10),
      );
    });

    test('getSummaryById returns the loan with its aggregates', () async {
      final loans = container.read(loanRepositoryProvider);

      final summary = await loans.getSummaryById(loanId);

      expect(summary?.loan.note, 'voiture');
      expect(summary?.repaid, const Money(1500));
      expect(summary?.firstRepaymentDate, LocalDay(2026, 9, 10));
      expect(summary?.lastRepaymentDate, LocalDay(2026, 9, 20));
      expect(await loans.getSummaryById(loanId + 100), isNull);
    });

    test('watchSummaryById re-emits on repayment changes (US-3.2)', () async {
      final loans = container.read(loanRepositoryProvider);
      final repayments = container.read(repaymentRepositoryProvider);

      final summaries = loans.watchSummaryById(loanId);
      final expectation = expectLater(
        summaries.map((s) => s?.repaid),
        emitsInOrder([const Money(1500), const Money(5000), null]),
      );
      await Future<void>.delayed(Duration.zero);
      await repayments.add(
        loanId: loanId,
        amount: const Money(3500),
        repaymentDate: LocalDay(2026, 9, 25),
      );
      await Future<void>.delayed(Duration.zero);
      await loans.delete(loanId);

      await expectation;
    });

    test('watchByLoan lists repayments most recent first (US-3.2)', () async {
      final history = await container
          .read(repaymentRepositoryProvider)
          .watchByLoan(loanId)
          .first;

      expect(
        [for (final r in history) r.repaymentDate],
        [LocalDay(2026, 9, 20), LocalDay(2026, 9, 10)],
      );
    });

    test('update stores the new values and keeps the repayments', () async {
      final loans = container.read(loanRepositoryProvider);
      final loan = (await loans.getSummaryById(loanId))!.loan;
      final updated = loan.copyWith(
        amount: const Money(8000),
        loanDate: LocalDay(2026, 8, 31),
        promisedReturnDate: LocalDay(2026, 12, 1),
        note: null,
      );

      await loans.update(updated);

      final summary = await loans.getSummaryById(loanId);
      expect(summary?.loan, updated);
      expect(summary?.repaid, const Money(1500));
    });

    test('update of a missing loan throws LoanNotFoundException', () async {
      final loans = container.read(loanRepositoryProvider);
      final loan = (await loans.getSummaryById(loanId))!.loan;

      await expectLater(
        loans.update(loan.copyWith(id: loanId + 100)),
        throwsA(isA<LoanNotFoundException>()),
      );
    });

    test('delete removes the loan and its repayments (RG-14)', () async {
      final loans = container.read(loanRepositoryProvider);
      final repayments = container.read(repaymentRepositoryProvider);

      await loans.delete(loanId);

      expect(await loans.getSummaryById(loanId), isNull);
      expect(await repayments.watchByLoan(loanId).first, isEmpty);
      expect(await loans.watchByBorrower(borrowerId).first, isEmpty);
    });

    test('repayment update changes the loan aggregates (US-3.3)', () async {
      final loans = container.read(loanRepositoryProvider);
      final repayments = container.read(repaymentRepositoryProvider);
      final latest = (await repayments.watchByLoan(loanId).first).first;
      final updated = latest.copyWith(
        amount: const Money(4500),
        repaymentDate: LocalDay(2026, 9, 5),
        note: 'virement',
      );

      await repayments.update(updated);

      final history = await repayments.watchByLoan(loanId).first;
      expect(history.last, updated);
      final summary = await loans.getSummaryById(loanId);
      expect(summary?.repaid, const Money(5000));
      expect(summary?.firstRepaymentDate, LocalDay(2026, 9, 5));
    });

    test('update of a missing repayment throws', () async {
      final repayments = container.read(repaymentRepositoryProvider);
      final latest = (await repayments.watchByLoan(loanId).first).first;

      await expectLater(
        repayments.update(latest.copyWith(id: latest.id + 100)),
        throwsA(isA<RepaymentNotFoundException>()),
      );
    });

    test('repayment delete updates the loan aggregates (US-3.3)', () async {
      final loans = container.read(loanRepositoryProvider);
      final repayments = container.read(repaymentRepositoryProvider);
      final latest = (await repayments.watchByLoan(loanId).first).first;

      await repayments.delete(latest.id);

      expect(await repayments.watchByLoan(loanId).first, hasLength(1));
      expect((await loans.getSummaryById(loanId))?.repaid, const Money(500));
    });
  });

  test('deleting a borrower through the repository cascades', () async {
    final borrowers = container.read(borrowerRepositoryProvider);
    final loans = container.read(loanRepositoryProvider);
    final borrowerId = await borrowers.add(name: 'Ali');
    await loans.add(
      borrowerId: borrowerId,
      amount: const Money(1000),
      loanDate: LocalDay(2026, 10, 1),
    );

    await borrowers.delete(borrowerId);

    expect(await borrowers.watchAll().first, isEmpty);
    expect(await loans.watchByBorrower(borrowerId).first, isEmpty);
  });
}
