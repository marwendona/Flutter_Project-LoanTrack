import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';

void main() {
  test('TND is the default, first supported currency with 3 decimals', () {
    expect(Currency.supported.first, Currency.tnd);
    expect(Currency.tnd.decimals, 3);
  });

  test('supported currencies have unique codes', () {
    final codes = Currency.supported.map((c) => c.code).toSet();
    expect(codes, hasLength(Currency.supported.length));
  });

  test('fromCode finds a supported currency with its decimals', () {
    expect(Currency.fromCode('TND'), Currency.tnd);
    expect(Currency.fromCode('EUR'), const Currency(code: 'EUR', decimals: 2));
    expect(Currency.fromCode('LYD')?.decimals, 3);
  });

  test('fromCode returns null for an unknown or missing code', () {
    expect(Currency.fromCode('XYZ'), isNull);
    expect(Currency.fromCode('tnd'), isNull);
    expect(Currency.fromCode(null), isNull);
  });
}
