import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_parser.dart';

void main() {
  const eur = Currency(code: 'EUR', decimals: 2);
  const jpy = Currency(code: 'JPY', decimals: 0);

  group('MoneyParser with TND (3 decimals)', () {
    Money? parse(String input) => MoneyParser.tryParse(input, Currency.tnd);

    test('parses user input into millimes', () {
      expect(parse('1250,5'), const Money(1250500));
      expect(parse('1250.5'), const Money(1250500));
      expect(parse('1250,500'), const Money(1250500));
      expect(parse('1250'), const Money(1250000));
      expect(parse('0,001'), const Money(1));
      expect(parse('12,'), const Money(12000));
      expect(parse('007'), const Money(7000));
    });

    test('accepts spaces as thousands separators and surrounding spaces', () {
      expect(parse(' 1 250,5 '), const Money(1250500));
      expect(parse('1 250,5'), const Money(1250500));
      expect(parse('1 000 000'), const Money(1000000000));
    });

    test('parses zero (range checks belong to business validation)', () {
      expect(parse('0'), Money.zero);
      expect(parse('0,000'), Money.zero);
    });

    test('rejects invalid input', () {
      for (final input in [
        '',
        '   ',
        'abc',
        '12a',
        '-5',
        '+5',
        ',5',
        '1,2,3',
        '1.250,5',
        '1,2345',
        '1e3',
        '1234567890123456',
      ]) {
        expect(parse(input), isNull, reason: 'input "$input"');
      }
    });
  });

  group('MoneyParser with other currencies', () {
    test('2 decimals (EUR)', () {
      expect(MoneyParser.tryParse('19,99', eur), const Money(1999));
      expect(MoneyParser.tryParse('19,9', eur), const Money(1990));
      expect(MoneyParser.tryParse('19,999', eur), isNull);
    });

    test('0 decimals (JPY)', () {
      expect(MoneyParser.tryParse('1500', jpy), const Money(1500));
      expect(MoneyParser.tryParse('1500,', jpy), const Money(1500));
      expect(MoneyParser.tryParse('1500,5', jpy), isNull);
    });
  });
}
