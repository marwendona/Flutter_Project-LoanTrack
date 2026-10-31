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
import 'package:loantrack/domain/models/repayment.dart';

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
        name: ' Ali ',
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
