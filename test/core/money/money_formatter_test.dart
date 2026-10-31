import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_formatter.dart';

void main() {
  const s = MoneyFormatter.nbsp;
  const eur = Currency(code: 'EUR', decimals: 2);
  const jpy = Currency(code: 'JPY', decimals: 0);

  group('MoneyFormatter', () {
    test('formats TND with 3 decimals, thousands spaces and code', () {
      expect(
        MoneyFormatter.format(const Money(1250500), Currency.tnd),
        '1${s}250,500${s}TND',
      );
      expect(MoneyFormatter.format(Money.zero, Currency.tnd), '0,000${s}TND');
      expect(
        MoneyFormatter.format(const Money(5), Currency.tnd),
        '0,005${s}TND',
      );
      expect(
        MoneyFormatter.format(const Money(999999999999), Currency.tnd),
        '999${s}999${s}999,999${s}TND',
      );
    });

    test('formats 2 and 0 decimal currencies', () {
      expect(MoneyFormatter.format(const Money(1999), eur), '19,99${s}EUR');
      expect(
        MoneyFormatter.format(const Money(100005), eur),
        '1${s}000,05${s}EUR',
      );
      expect(
        MoneyFormatter.format(const Money(1234567), jpy),
        '1${s}234${s}567${s}JPY',
      );
    });

    test('formats negative amounts', () {
      expect(
        MoneyFormatter.formatAmount(const Money(-1250500), Currency.tnd),
        '-1${s}250,500',
      );
    });

    test('formatAmount omits the currency code', () {
      expect(
        MoneyFormatter.formatAmount(const Money(123), Currency.tnd),
        '0,123',
      );
    });
  });
}
