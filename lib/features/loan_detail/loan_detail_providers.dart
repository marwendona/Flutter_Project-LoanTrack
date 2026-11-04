import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date/local_day.dart';
import '../../data/providers.dart';
import '../../domain/models/loan_status.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/models/repayment.dart';
import '../../domain/services/loan_status_calculator.dart';

/// Everything ECR-05 shows: the loan with its status of the day (RG-20) and its
/// repayments, most recent first.
typedef LoanDetail = ({
  LoanSummary summary,
  LoanStatus status,
  List<Repayment> repayments,
});

final _loanSummaryProvider = StreamProvider.family<LoanSummary?, int>(
  (ref, loanId) => ref.watch(loanRepositoryProvider).watchSummaryById(loanId),
);

final _repaymentsProvider = StreamProvider.family<List<Repayment>, int>(
  (ref, loanId) => ref.watch(repaymentRepositoryProvider).watchByLoan(loanId),
);

/// The detail of a loan, null if it does not exist (e.g. just deleted).
/// Updated whenever the loan or one of its repayments changes.
final loanDetailProvider = FutureProvider.family<LoanDetail?, int>((
  ref,
  loanId,
) async {
  final summary = await ref.watch(_loanSummaryProvider(loanId).future);
  final repayments = await ref.watch(_repaymentsProvider(loanId).future);
  if (summary == null) return null;
  return (
    summary: summary,
    status: LoanStatusCalculator.compute(summary, LocalDay.today()),
    repayments: repayments,
  );
});
