import 'package:freezed_annotation/freezed_annotation.dart';

import 'reliability_color.dart';

part 'borrower_reliability.freezed.dart';

/// Derived reliability of a borrower (RG-62). Never stored nor exported (RG-63).
@freezed
abstract class BorrowerReliability with _$BorrowerReliability {
  const factory BorrowerReliability({
    /// Number of loans on time or late (RG-60).
    required int evaluatedLoanCount,

    /// N: number of late loans.
    required int lateLoanCount,

    /// L: number of late loans whose delay is long (RG-61).
    required int longDelayCount,
    required ReliabilityColor color,
  }) = _BorrowerReliability;

  const BorrowerReliability._();

  /// Reliability of a borrower without any evaluated loan (Q-12).
  static const notEvaluated = BorrowerReliability(
    evaluatedLoanCount: 0,
    lateLoanCount: 0,
    longDelayCount: 0,
    color: ReliabilityColor.notEvaluated,
  );
}
