/// Reliability color of a borrower (RG-62), declared from the most to the
/// least reliable (RG-64): compare them with [compareTo]. Never stored (RG-63).
enum ReliabilityColor implements Comparable<ReliabilityColor> {
  /// Every evaluated loan was repaid on time.
  green,

  /// One short delay.
  blue,

  /// One long delay.
  purple,

  /// Two short delays.
  yellow,

  /// Two delays, one of them long.
  orange,

  /// Two long delays, or three delays.
  red,

  /// More than three delays.
  black,

  /// Grey: no evaluated loan yet (Q-12).
  notEvaluated;

  @override
  int compareTo(ReliabilityColor other) => index.compareTo(other.index);
}

/// Punctuality of a single loan (RG-60, RG-61).
enum LoanPunctuality {
  /// No promised return date, or not repaid yet and not due yet.
  notEvaluable,

  /// Fully repaid on or before the promised return date.
  onTime,

  /// Late by at most one month.
  shortDelay,

  /// Late by more than one month.
  longDelay;

  /// Whether the loan counts for the reliability (on time or late).
  bool get isEvaluated => this != notEvaluable;

  bool get isLate => this == shortDelay || this == longDelay;
}
