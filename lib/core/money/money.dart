/// An amount of money in minor units of the app currency
/// (TND: millimes, `1 250,500 TND` → `1250500`).
///
/// Never use `double` for money: all arithmetic stays on `int` (ENF-05).
final class Money implements Comparable<Money> {
  const Money(this.amountMinor);

  static const zero = Money(0);

  final int amountMinor;

  bool get isZero => amountMinor == 0;
  bool get isPositive => amountMinor > 0;
  bool get isNegative => amountMinor < 0;

  Money operator +(Money other) => Money(amountMinor + other.amountMinor);
  Money operator -(Money other) => Money(amountMinor - other.amountMinor);
  Money operator -() => Money(-amountMinor);

  bool operator <(Money other) => amountMinor < other.amountMinor;
  bool operator <=(Money other) => amountMinor <= other.amountMinor;
  bool operator >(Money other) => amountMinor > other.amountMinor;
  bool operator >=(Money other) => amountMinor >= other.amountMinor;

  @override
  int compareTo(Money other) => amountMinor.compareTo(other.amountMinor);

  @override
  bool operator ==(Object other) =>
      other is Money && other.amountMinor == amountMinor;

  @override
  int get hashCode => amountMinor.hashCode;

  @override
  String toString() => 'Money($amountMinor)';
}
