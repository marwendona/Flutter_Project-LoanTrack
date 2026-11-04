import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date/local_day.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower_summary.dart';
import '../../domain/models/borrower_summary_filter.dart';
import '../../domain/models/global_totals.dart';
import '../../domain/services/global_totals_calculator.dart';
import '../borrowers/borrowers_providers.dart';

/// Totals over all borrowers and loans (RG-31 to RG-33), updated whenever a
/// borrower, loan or repayment changes.
final globalTotalsProvider = StreamProvider<GlobalTotals>(
  (ref) => ref
      .watch(borrowerRepositoryProvider)
      .watchAllWithLoanBalances()
      .map(
        (entries) => GlobalTotalsCalculator.compute(entries, LocalDay.today()),
      ),
);

/// Selected filter of the "Par emprunteur" list (US-4.3), kept for the
/// session only.
final dashboardFilterProvider =
    NotifierProvider<DashboardFilterNotifier, BorrowerSummaryFilter>(
      DashboardFilterNotifier.new,
    );

class DashboardFilterNotifier extends Notifier<BorrowerSummaryFilter> {
  @override
  BorrowerSummaryFilter build() => BorrowerSummaryFilter.all;

  void select(BorrowerSummaryFilter filter) => state = filter;
}

/// Borrowers of the "Par emprunteur" list matching the selected filter, in
/// the RG-04 order.
final dashboardBorrowersProvider = Provider<List<BorrowerSummary>>((ref) {
  final summaries = ref.watch(borrowerSummariesProvider).value ?? const [];
  return ref.watch(dashboardFilterProvider).apply(summaries);
});
