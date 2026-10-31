import 'package:clock/clock.dart';

/// A calendar day without time nor time zone (e.g. a loan date).
///
/// Stored as the number of days since 1970-01-01 ([epochDay]). Computations
/// go through UTC so daylight saving time changes never shift a day.
final class LocalDay implements Comparable<LocalDay> {
  /// Throws an [ArgumentError] if the date does not exist (e.g. 30 February).
  factory LocalDay(int year, int month, int day) {
    final utc = DateTime.utc(year, month, day);
    if (utc.year != year || utc.month != month || utc.day != day) {
      throw ArgumentError('Invalid date: $year-$month-$day');
    }
    return LocalDay._(utc.millisecondsSinceEpoch ~/ _msPerDay);
  }

  const LocalDay.fromEpochDay(int epochDay) : this._(epochDay);

  /// The calendar day of [dateTime] as seen in its own time zone.
  factory LocalDay.fromDateTime(DateTime dateTime) =>
      LocalDay(dateTime.year, dateTime.month, dateTime.day);

  /// Today on the device, read from [clock] so tests can freeze it.
  factory LocalDay.today() => LocalDay.fromDateTime(clock.now());

  const LocalDay._(this.epochDay);

  static const _msPerDay = Duration.millisecondsPerDay;

  final int epochDay;

  DateTime get _utc =>
      DateTime.fromMillisecondsSinceEpoch(epochDay * _msPerDay, isUtc: true);

  int get year => _utc.year;
  int get month => _utc.month;
  int get day => _utc.day;

  bool isBefore(LocalDay other) => epochDay < other.epochDay;
  bool isAfter(LocalDay other) => epochDay > other.epochDay;

  bool operator <(LocalDay other) => epochDay < other.epochDay;
  bool operator <=(LocalDay other) => epochDay <= other.epochDay;
  bool operator >(LocalDay other) => epochDay > other.epochDay;
  bool operator >=(LocalDay other) => epochDay >= other.epochDay;

  @override
  int compareTo(LocalDay other) => epochDay.compareTo(other.epochDay);

  @override
  bool operator ==(Object other) =>
      other is LocalDay && other.epochDay == epochDay;

  @override
  int get hashCode => epochDay.hashCode;

  /// ISO 8601 (`2026-10-30`), for logs and debugging only.
  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${_twoDigits(month)}-${_twoDigits(day)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
