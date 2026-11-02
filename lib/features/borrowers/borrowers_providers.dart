import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date/local_day.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower_summary.dart';
import '../../domain/services/borrower_summary_calculator.dart';

/// Borrowers with their totals, sorted by remaining due then name (RG-04).
/// Updated whenever a borrower, loan or repayment changes.
final borrowerSummariesProvider = StreamProvider<List<BorrowerSummary>>(
  (ref) => ref
      .watch(borrowerRepositoryProvider)
      .watchAllWithLoanBalances()
      .map(
        (entries) =>
            BorrowerSummaryCalculator.summarizeAll(entries, LocalDay.today()),
      ),
);
