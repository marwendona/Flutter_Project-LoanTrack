import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/date_formatter.dart';
import 'package:loantrack/core/date/local_day.dart';

void main() {
  group('LocalDay', () {
    test('converts to and from epochDay', () {
      expect(LocalDay(1970, 1, 1).epochDay, 0);
      expect(LocalDay(1970, 1, 2).epochDay, 1);
      expect(LocalDay(1969, 12, 31).epochDay, -1);
      final day = LocalDay(2026, 10, 30);
      final roundTrip = LocalDay.fromEpochDay(day.epochDay);
      expect(roundTrip, day);
      expect((roundTrip.year, roundTrip.month, roundTrip.day), (2026, 10, 30));
    });

    test('rejects dates that do not exist', () {
      expect(() => LocalDay(2026, 2, 29), throwsArgumentError);
      expect(() => LocalDay(2026, 13, 1), throwsArgumentError);
      expect(LocalDay(2028, 2, 29).day, 29);
    });

    test('today() comes from the injected clock', () {
      final today = withClock(
        Clock.fixed(DateTime(2026, 10, 30, 23, 59, 59)),
        LocalDay.today,
      );
      expect(today, LocalDay(2026, 10, 30));
    });

    test('ignores the time of day', () {
      expect(
        LocalDay.fromDateTime(DateTime(2026, 10, 30)),
        LocalDay.fromDateTime(DateTime(2026, 10, 30, 23, 59, 59, 999)),
      );
    });

    test('is not shifted by daylight saving time changes', () {
      // Last Sundays of March and October: DST changes in Europe.
      for (final (year, month, day) in [(2026, 3, 29), (2026, 10, 25)]) {
        final before = LocalDay.fromDateTime(
          DateTime(year, month, day - 1, 12),
        );
        final early = LocalDay.fromDateTime(DateTime(year, month, day));
        final late = LocalDay.fromDateTime(DateTime(year, month, day, 23, 59));
        final after = LocalDay.fromDateTime(DateTime(year, month, day + 1));
        expect(early, LocalDay(year, month, day));
        expect(late, early);
        expect(early.epochDay - before.epochDay, 1);
        expect(after.epochDay - early.epochDay, 1);
      }
    });

    test('compares days', () {
      final a = LocalDay(2026, 10, 29);
      final b = LocalDay(2026, 10, 30);
      expect(a.isBefore(b), isTrue);
      expect(b.isAfter(a), isTrue);
      expect(a < b && a <= a && b > a && b >= b, isTrue);
      expect([b, a]..sort(), [a, b]);
      expect(LocalDay(2026, 10, 30), b);
      expect(LocalDay(2026, 10, 30).hashCode, b.hashCode);
    });
  });

  group('DateFormatter', () {
    test('formats as dd/MM/yyyy', () {
      expect(DateFormatter.format(LocalDay(2026, 10, 30)), '30/10/2026');
      expect(DateFormatter.format(LocalDay(2026, 1, 5)), '05/01/2026');
    });
  });
}
