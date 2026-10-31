import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/money.dart';

void main() {
  group('Money', () {
    test('adds and subtracts minor units exactly', () {
      expect(const Money(1250500) + const Money(500), const Money(1251000));
      expect(const Money(1250500) - const Money(250500), const Money(1000000));
      expect(const Money(100) - const Money(300), const Money(-200));
      expect(-const Money(5), const Money(-5));
    });

    test('has no rounding error where doubles would (0.1 + 0.2)', () {
      expect(const Money(100) + const Money(200), const Money(300));
    });

    test('compares amounts', () {
      const small = Money(1);
      const big = Money(2);
      expect(small < big, isTrue);
      expect(small <= small, isTrue);
      expect(big > small, isTrue);
      expect(big >= big, isTrue);
      expect(small.compareTo(big), lessThan(0));
      expect([big, Money.zero, small]..sort(), [Money.zero, small, big]);
    });

    test('exposes sign helpers', () {
      expect(Money.zero.isZero, isTrue);
      expect(const Money(1).isPositive, isTrue);
      expect(const Money(-1).isNegative, isTrue);
    });

    test('implements value equality', () {
      expect(const Money(42), const Money(42));
      expect(const Money(42).hashCode, const Money(42).hashCode);
      expect(const Money(42), isNot(const Money(43)));
    });
  });
}
