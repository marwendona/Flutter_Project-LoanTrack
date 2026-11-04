import 'package:material_ui/material_ui.dart';

import '../date/date_formatter.dart';
import '../date/local_day.dart';

/// A read-only field showing a day; tapping it opens a date picker.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.errorText,
    this.emptyText,
    this.onClear,
    this.clearTooltip,
  });

  final String label;
  final LocalDay? value;
  final VoidCallback onTap;
  final String? errorText;

  /// Shown when [value] is null.
  final String? emptyText;

  /// When set, a clear button is shown while [value] is not null.
  final VoidCallback? onClear;
  final String? clearTooltip;

  /// Opens the system date picker between [first] and [last], starting at
  /// [initial] (clamped to the bounds).
  static Future<LocalDay?> pick(
    BuildContext context, {
    required LocalDay initial,
    required DateTime first,
    required DateTime last,
  }) async {
    var initialDate = toDateTime(initial);
    if (initialDate.isBefore(first)) initialDate = first;
    if (initialDate.isAfter(last)) initialDate = last;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: first,
      lastDate: last,
    );
    return picked == null ? null : LocalDay.fromDateTime(picked);
  }

  /// Midnight of [day], for the date picker bounds.
  static DateTime toDateTime(LocalDay day) =>
      DateTime(day.year, day.month, day.day);

  @override
  Widget build(BuildContext context) {
    final day = value;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          suffixIcon: day != null && onClear != null
              ? IconButton(
                  tooltip: clearTooltip,
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
        ),
        child: Text(day != null ? DateFormatter.format(day) : emptyText ?? ''),
      ),
    );
  }
}
