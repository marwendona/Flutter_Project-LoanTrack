import 'currency.dart';
import 'money.dart';

/// Formats [Money] the French way: `1 250,500 TND`.
///
/// Integer arithmetic only (no `double`), so no rounding error is possible.
/// Spaces are non-breaking so an amount never wraps over two lines.
abstract final class MoneyFormatter {
  static const nbsp = ' ';

  /// `1250500` in TND → `1 250,500 TND`.
  static String format(Money money, Currency currency) =>
      '${formatAmount(money, currency)}$nbsp${currency.code}';

  /// Same as [format] without the currency code: `1 250,500`.
  static String formatAmount(Money money, Currency currency) {
    final minor = money.amountMinor.abs();
    final factor = currency.minorUnitsPerMajor;
    final sign = money.isNegative ? '-' : '';
    final integerPart = _groupThousands((minor ~/ factor).toString());
    if (currency.decimals == 0) return '$sign$integerPart';

    final fractionPart = (minor % factor).toString().padLeft(
      currency.decimals,
      '0',
    );
    return '$sign$integerPart,$fractionPart';
  }

  static String _groupThousands(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(nbsp);
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
