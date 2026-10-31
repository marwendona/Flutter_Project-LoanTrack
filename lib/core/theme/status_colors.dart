import 'package:material_ui/material_ui.dart';

/// Loan status colors (screens spec, "Formats d'affichage"): repaid = green,
/// overdue = red, partially repaid = orange, ongoing = neutral blue.
///
/// A status is always shown with a text label too, never with color alone.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.repaid,
    required this.overdue,
    required this.partiallyRepaid,
    required this.ongoing,
  });

  static const light = StatusColors(
    repaid: Color(0xFF2E7D32),
    overdue: Color(0xFFC62828),
    partiallyRepaid: Color(0xFFE65100),
    ongoing: Color(0xFF1565C0),
  );

  static const dark = StatusColors(
    repaid: Color(0xFF81C784),
    overdue: Color(0xFFEF9A9A),
    partiallyRepaid: Color(0xFFFFB74D),
    ongoing: Color(0xFF90CAF9),
  );

  final Color repaid;
  final Color overdue;
  final Color partiallyRepaid;
  final Color ongoing;

  static StatusColors of(BuildContext context) =>
      Theme.of(context).extension<StatusColors>()!;

  @override
  StatusColors copyWith({
    Color? repaid,
    Color? overdue,
    Color? partiallyRepaid,
    Color? ongoing,
  }) {
    return StatusColors(
      repaid: repaid ?? this.repaid,
      overdue: overdue ?? this.overdue,
      partiallyRepaid: partiallyRepaid ?? this.partiallyRepaid,
      ongoing: ongoing ?? this.ongoing,
    );
  }

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      repaid: Color.lerp(repaid, other.repaid, t)!,
      overdue: Color.lerp(overdue, other.overdue, t)!,
      partiallyRepaid: Color.lerp(partiallyRepaid, other.partiallyRepaid, t)!,
      ongoing: Color.lerp(ongoing, other.ongoing, t)!,
    );
  }
}
