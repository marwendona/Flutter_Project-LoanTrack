import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date/local_day.dart';
import '../../data/providers.dart';
import '../../domain/models/global_totals.dart';
import '../../domain/services/global_totals_calculator.dart';

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
