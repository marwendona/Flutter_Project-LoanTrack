import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date/local_day.dart';
import '../../core/string/string_normalizer.dart';
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

/// Search query for filtering borrowers (US-1.5).
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String value) => state = value;
}

/// Borrowers filtered by search query (case and accent insensitive).
final filteredBorrowersProvider = Provider<List<BorrowerSummary>>((ref) {
  final summariesAsync = ref.watch(borrowerSummariesProvider);
  final query = ref.watch(searchQueryProvider);

  final summaries = summariesAsync.value ?? [];
  if (query.isEmpty) return summaries;

  final normalizedQuery = StringNormalizer.normalize(query);
  return summaries.where((summary) {
    final normalizedName = StringNormalizer.normalize(summary.borrower.name);
    return normalizedName.contains(normalizedQuery);
  }).toList();
});
