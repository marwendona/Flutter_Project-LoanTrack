import '../models/borrower_summary.dart';
import '../models/reliability_color.dart';
import 'borrower_summary_calculator.dart';

/// Borrowers sharing the same reliability color (ECR-07).
typedef ReliabilityGroup = ({
  ReliabilityColor color,
  List<BorrowerSummary> borrowers,
});

/// Groups the borrowers by reliability color (RG-62).
abstract final class ReliabilityGrouping {
  /// One group per color in the RG-64 order (green to black, then not
  /// evaluated), colors without any borrower omitted; each group is sorted by
  /// remaining due then name (RG-04).
  static List<ReliabilityGroup> group(Iterable<BorrowerSummary> summaries) {
    final byColor = <ReliabilityColor, List<BorrowerSummary>>{};
    for (final summary in summaries) {
      byColor.putIfAbsent(summary.reliability.color, () => []).add(summary);
    }
    return [
      for (final color in ReliabilityColor.values)
        if (byColor[color] case final borrowers?)
          (
            color: color,
            borrowers: borrowers
              ..sort(BorrowerSummaryCalculator.compareByRemainingThenName),
          ),
    ];
  }
}
