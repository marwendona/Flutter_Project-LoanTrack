import 'borrower_summary.dart';

/// Quick filter of the "Par emprunteur" list of the dashboard (US-4.3).
enum BorrowerSummaryFilter {
  /// Every borrower.
  all,

  /// Borrowers whose remaining due is > 0.
  withRemaining,

  /// Borrowers with at least one overdue loan (RG-21).
  overdue;

  bool matches(BorrowerSummary summary) => switch (this) {
    all => true,
    withRemaining => summary.remaining.isPositive,
    overdue => summary.isOverdue,
  };

  /// Keeps the order of [summaries] (RG-04).
  List<BorrowerSummary> apply(List<BorrowerSummary> summaries) =>
      this == all ? summaries : summaries.where(matches).toList();
}
