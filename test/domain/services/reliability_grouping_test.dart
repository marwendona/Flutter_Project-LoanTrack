import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_reliability.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/domain/models/reliability_color.dart';
import 'package:loantrack/domain/services/reliability_grouping.dart';

void main() {
  BorrowerSummary summary(
    int id,
    String name,
    ReliabilityColor color, {
    int remaining = 0,
  }) => BorrowerSummary(
    borrower: Borrower(id: id, name: name, createdAt: LocalDay(2026, 10, 1)),
    totalLent: Money(remaining),
    totalRepaid: Money.zero,
    loanCount: 1,
    activeLoanCount: remaining > 0 ? 1 : 0,
    overdueLoanCount: 0,
    reliability: BorrowerReliability.notEvaluated.copyWith(color: color),
  );

  List<String> names(ReliabilityGroup group) => [
    for (final s in group.borrowers) s.borrower.name,
  ];

  test('no borrower gives no group', () {
    expect(ReliabilityGrouping.group(const []), isEmpty);
  });

  test('one group per color in the RG-64 order, empty colors omitted', () {
    final groups = ReliabilityGrouping.group([
      summary(1, 'A', ReliabilityColor.notEvaluated),
      summary(2, 'B', ReliabilityColor.black),
      summary(3, 'C', ReliabilityColor.green),
      summary(4, 'D', ReliabilityColor.orange),
      summary(5, 'E', ReliabilityColor.blue),
      summary(6, 'F', ReliabilityColor.green),
    ]);

    expect(
      [for (final g in groups) g.color],
      [
        ReliabilityColor.green,
        ReliabilityColor.blue,
        ReliabilityColor.orange,
        ReliabilityColor.black,
        ReliabilityColor.notEvaluated,
      ],
    );
    expect([for (final g in groups) g.borrowers.length], [2, 1, 1, 1, 1]);
  });

  test('every color, in the RG-64 order', () {
    final groups = ReliabilityGrouping.group([
      for (final color in ReliabilityColor.values.reversed)
        summary(color.index, color.name, color),
    ]);

    expect([for (final g in groups) g.color], ReliabilityColor.values);
  });

  test('each group is sorted by remaining due, then name (RG-04)', () {
    final groups = ReliabilityGrouping.group([
      summary(1, 'zied', ReliabilityColor.red, remaining: 1000),
      summary(2, 'Ali', ReliabilityColor.red, remaining: 1000),
      summary(3, 'Sami', ReliabilityColor.red, remaining: 5000),
      summary(4, 'Mona', ReliabilityColor.red),
    ]);

    expect(groups, hasLength(1));
    expect(names(groups.single), ['Sami', 'Ali', 'zied', 'Mona']);
  });
}
