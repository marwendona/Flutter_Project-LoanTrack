import 'local_day.dart';

/// Formats days for display: `dd/MM/yyyy` (e.g. `30/10/2026`).
abstract final class DateFormatter {
  static String format(LocalDay day) =>
      '${_pad(day.day, 2)}/${_pad(day.month, 2)}/${_pad(day.year, 4)}';

  static String _pad(int value, int width) =>
      value.toString().padLeft(width, '0');
}
