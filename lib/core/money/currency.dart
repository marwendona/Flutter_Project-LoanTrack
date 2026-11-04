/// A currency identified by its ISO 4217 code (RG-40).
final class Currency {
  const Currency({required this.code, required this.decimals})
    : assert(decimals >= 0 && decimals <= 3);

  /// Tunisian dinar: the default currency, 1 TND = 1000 millimes.
  static const tnd = Currency(code: 'TND', decimals: 3);

  /// The currencies offered in the settings (ECR-06, CR-027), default first.
  static const supported = [
    tnd,
    Currency(code: 'EUR', decimals: 2),
    Currency(code: 'USD', decimals: 2),
    Currency(code: 'GBP', decimals: 2),
    Currency(code: 'CHF', decimals: 2),
    Currency(code: 'CAD', decimals: 2),
    Currency(code: 'MAD', decimals: 2),
    Currency(code: 'DZD', decimals: 2),
    Currency(code: 'LYD', decimals: 3),
  ];

  /// The supported currency with this ISO 4217 [code], null if unknown.
  static Currency? fromCode(String? code) {
    for (final currency in supported) {
      if (currency.code == code) return currency;
    }
    return null;
  }

  final String code;

  /// Number of decimal digits of the minor unit (TND: 3, EUR: 2, JPY: 0).
  final int decimals;

  /// Number of minor units in one major unit (TND: 1000).
  int get minorUnitsPerMajor {
    var factor = 1;
    for (var i = 0; i < decimals; i++) {
      factor *= 10;
    }
    return factor;
  }

  @override
  bool operator ==(Object other) =>
      other is Currency && other.code == code && other.decimals == decimals;

  @override
  int get hashCode => Object.hash(code, decimals);

  @override
  String toString() => code;
}
