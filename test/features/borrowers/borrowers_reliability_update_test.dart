// US-7.2: the reliability color shown on ECR-02 and ECR-03 is updated as soon
// as a loan or a repayment is added, edited or deleted (RG-63).
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/database/app_database.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/models/reliability_color.dart';
import 'package:loantrack/domain/models/repayment.dart';
import 'package:loantrack/features/borrower_detail/borrower_detail_providers.dart';
import 'package:loantrack/features/borrowers/borrowers_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    // Keeps the providers alive between two reads.
    container.listen(borrowerSummariesProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  /// Colors of ECR-02 and ECR-03 once the database streams have emitted.
  Future<(ReliabilityColor, ReliabilityColor)> colors(int borrowerId) async {
    await pumpEventQueue();
    final list = await container.read(borrowerSummariesProvider.future);
    final detail = await container.read(
      borrowerDetailProvider(borrowerId).future,
    );
    return (list.single.reliability.color, detail!.summary.reliability.color);
  }

  test('follows every change of a loan or a repayment', () async {
    final borrowerId = await container
        .read(borrowerRepositoryProvider)
        .add(name: 'Ali');
    container.listen(borrowerDetailProvider(borrowerId), (_, _) {});
    expect(await colors(borrowerId), (
      ReliabilityColor.notEvaluated,
      ReliabilityColor.notEvaluated,
    ));

    // Promised long ago and never repaid: one long delay.
    final loans = container.read(loanRepositoryProvider);
    final loanId = await loans.add(
      borrowerId: borrowerId,
      amount: const Money(1000000),
      loanDate: LocalDay(2020, 1, 1),
      promisedReturnDate: LocalDay(2020, 2, 1),
    );
    expect(await colors(borrowerId), (
      ReliabilityColor.purple,
      ReliabilityColor.purple,
    ));

    // Fully repaid 10 days late: one short delay.
    final repayments = container.read(repaymentRepositoryProvider);
    final repaymentId = await repayments.add(
      loanId: loanId,
      amount: const Money(1000000),
      repaymentDate: LocalDay(2020, 2, 11),
    );
    expect(await colors(borrowerId), (
      ReliabilityColor.blue,
      ReliabilityColor.blue,
    ));

    // Repayment moved before the promised date: on time.
    await repayments.update(
      Repayment(
        id: repaymentId,
        loanId: loanId,
        amount: const Money(1000000),
        repaymentDate: LocalDay(2020, 1, 20),
      ),
    );
    expect(await colors(borrowerId), (
      ReliabilityColor.green,
      ReliabilityColor.green,
    ));

    // Repayment deleted: late again, by more than a month.
    await repayments.delete(repaymentId);
    expect(await colors(borrowerId), (
      ReliabilityColor.purple,
      ReliabilityColor.purple,
    ));

    // Loan deleted: nothing left to evaluate.
    await loans.delete(loanId);
    expect(await colors(borrowerId), (
      ReliabilityColor.notEvaluated,
      ReliabilityColor.notEvaluated,
    ));
  });
}
