import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/domain/models/borrower_summary_filter.dart';

void main() {
  BorrowerSummary summary(
    String name, {
    int lent = 0,
    int repaid = 0,
    int overdue = 0,
  }) => BorrowerSummary(
    borrower: Borrower(id: 0, name: name, createdAt: LocalDay(2026, 10, 1)),
    totalLent: Money(lent),
    totalRepaid: Money(repaid),
    loanCount: lent > 0 ? 1 : 0,
    activeLoanCount: lent > repaid ? 1 : 0,
    overdueLoanCount: overdue,
  );

  final late = summary('Late', lent: 1000, repaid: 200, overdue: 1);
  final owing = summary('Owing', lent: 500);
  final repaid = summary('Repaid', lent: 300, repaid: 300);
  final noLoan = summary('NoLoan');
  final all = [late, owing, repaid, noLoan];

  test('all keeps every borrower', () {
    expect(BorrowerSummaryFilter.all.apply(all), all);
  });

  test('withRemaining keeps borrowers whose remaining due is > 0', () {
    expect(BorrowerSummaryFilter.withRemaining.apply(all), [late, owing]);
  });

  test('overdue keeps borrowers with an overdue loan', () {
    expect(BorrowerSummaryFilter.overdue.apply(all), [late]);
  });

  test('keeps the input order (RG-04)', () {
    expect(BorrowerSummaryFilter.withRemaining.apply([owing, late]), [
      owing,
      late,
    ]);
  });

  test('returns an empty list when nothing matches', () {
    expect(BorrowerSummaryFilter.overdue.apply([owing, repaid]), isEmpty);
  });
}
