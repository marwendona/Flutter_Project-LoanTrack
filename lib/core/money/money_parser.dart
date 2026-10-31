import 'currency.dart';
import 'money.dart';

/// Parses an amount typed by the user into [Money].
///
/// Accepted: digits, an optional decimal separator (`,` or `.`) followed by at
/// most [Currency.decimals] digits, and spaces as thousands separators
/// (`"1250,5"`, `"1 250.500"`, `"12"`).
/// Range checks (> 0, maximum) are business validations, not parsing.
abstract final class MoneyParser {
  // 15 integer digits keep any amount far below the 64-bit int limit.
  static const _maxIntegerDigits = 15;
  static final _spaces = RegExp(r'[\s  ]');
  static final _pattern = RegExp(r'^(\d+)(?:[.,](\d*))?$');

  /// Returns the parsed amount, or `null` if [input] is not a valid amount.
  static Money? tryParse(String input, Currency currency) {
    final normalized = input.trim().replaceAll(_spaces, '');
    final match = _pattern.firstMatch(normalized);
    if (match == null) return null;

    final integerPart = match.group(1)!.replaceFirst(RegExp('^0+(?=.)'), '');
    final fractionPart = match.group(2) ?? '';
    if (integerPart.length > _maxIntegerDigits) return null;
    if (fractionPart.length > currency.decimals) return null;

    final fractionMinor = fractionPart.isEmpty
        ? 0
        : int.parse(fractionPart.padRight(currency.decimals, '0'));
    return Money(
      int.parse(integerPart) * currency.minorUnitsPerMajor + fractionMinor,
    );
  }
}
