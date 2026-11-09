import 'package:material_ui/material_ui.dart';

import '../../domain/models/reliability_color.dart';

/// Fixed reliability colors (RG-62, screens spec "Formats d'affichage"): they
/// never come from the dynamic (Material You) colors so that each color keeps
/// the same meaning everywhere.
///
/// A reliability color is always shown with its label too (ENF-08).
@immutable
class ReliabilityColors extends ThemeExtension<ReliabilityColors> {
  const ReliabilityColors({required this.colors, this.blackOutline});

  static const light = ReliabilityColors(
    colors: {
      ReliabilityColor.green: Color(0xFF2E7D32),
      ReliabilityColor.blue: Color(0xFF1565C0),
      ReliabilityColor.purple: Color(0xFF7B1FA2),
      ReliabilityColor.yellow: Color(0xFFFBC02D),
      ReliabilityColor.orange: Color(0xFFEF6C00),
      ReliabilityColor.red: Color(0xFFC62828),
      ReliabilityColor.black: Color(0xFF000000),
      ReliabilityColor.notEvaluated: Color(0xFF9E9E9E),
    },
  );

  /// Lighter shades readable on a dark surface; the black dot gets a light
  /// outline so that it stays visible.
  static const dark = ReliabilityColors(
    colors: {
      ReliabilityColor.green: Color(0xFF81C784),
      ReliabilityColor.blue: Color(0xFF64B5F6),
      ReliabilityColor.purple: Color(0xFFCE93D8),
      ReliabilityColor.yellow: Color(0xFFFFEE58),
      ReliabilityColor.orange: Color(0xFFFFB74D),
      ReliabilityColor.red: Color(0xFFE57373),
      ReliabilityColor.black: Color(0xFF000000),
      ReliabilityColor.notEvaluated: Color(0xFF9E9E9E),
    },
    blackOutline: Color(0xFFE0E0E0),
  );

  /// One color per [ReliabilityColor].
  final Map<ReliabilityColor, Color> colors;

  /// Outline of the black dot, null when none is needed (light mode).
  final Color? blackOutline;

  Color colorOf(ReliabilityColor color) => colors[color]!;

  Color? outlineOf(ReliabilityColor color) =>
      color == ReliabilityColor.black ? blackOutline : null;

  static ReliabilityColors of(BuildContext context) =>
      Theme.of(context).extension<ReliabilityColors>()!;

  @override
  ReliabilityColors copyWith({
    Map<ReliabilityColor, Color>? colors,
    Color? blackOutline,
  }) {
    return ReliabilityColors(
      colors: colors ?? this.colors,
      blackOutline: blackOutline ?? this.blackOutline,
    );
  }

  @override
  ReliabilityColors lerp(ReliabilityColors? other, double t) {
    if (other == null) return this;
    return ReliabilityColors(
      colors: {
        for (final color in ReliabilityColor.values)
          color: Color.lerp(colorOf(color), other.colorOf(color), t)!,
      },
      blackOutline: Color.lerp(blackOutline, other.blackOutline, t),
    );
  }
}
