import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date/local_day.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower.dart';
import '../../domain/models/borrower_summary.dart';
import '../../domain/models/loan_status.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/services/borrower_summary_calculator.dart';
import '../../domain/services/loan_status_calculator.dart';

/// A loan of the borrower detail with its status of the day (RG-20).
typedef LoanItem = ({LoanSummary summary, LoanStatus status});

/// Everything ECR-03 shows: the borrower with its totals (RG-30) and its loans,
/// most recent first (RG-15).
typedef BorrowerDetail = ({BorrowerSummary summary, List<LoanItem> loans});

final _borrowerProvider = StreamProvider.family<Borrower?, int>(
  (ref, borrowerId) =>
      ref.watch(borrowerRepositoryProvider).watchById(borrowerId),
);

final _loanSummariesProvider = StreamProvider.family<List<LoanSummary>, int>(
  (ref, borrowerId) =>
      ref.watch(loanRepositoryProvider).watchSummariesByBorrower(borrowerId),
);

/// The detail of a borrower, null if it does not exist (e.g. just deleted).
/// Updated whenever the borrower, one of its loans or repayments changes.
final borrowerDetailProvider = FutureProvider.family<BorrowerDetail?, int>((
  ref,
  borrowerId,
) async {
  final borrower = await ref.watch(_borrowerProvider(borrowerId).future);
  final loans = await ref.watch(_loanSummariesProvider(borrowerId).future);
  if (borrower == null) return null;
  final today = LocalDay.today();
  return (
    summary: BorrowerSummaryCalculator.summarize(borrower, [
      for (final loan in loans) loan.balance,
    ], today),
    loans: [
      for (final loan in loans)
        (summary: loan, status: LoanStatusCalculator.compute(loan, today)),
    ],
  );
});
