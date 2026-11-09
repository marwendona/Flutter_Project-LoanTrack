import 'package:material_ui/material_ui.dart';

import '../../domain/models/reliability_color.dart';
import '../../l10n/generated/app_localizations.dart';
import '../theme/reliability_colors.dart';

/// Dot of a reliability color followed by its label (RG-62): the label is
/// always shown, never the color alone (ENF-08).
class ReliabilityIndicator extends StatelessWidget {
  const ReliabilityIndicator({required this.color, this.style, super.key});

  final ReliabilityColor color;

  /// Style of the label, the default text style when null.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReliabilityDot(color: color),
        const SizedBox(width: 8),
        // Wraps rather than overflowing when the font is enlarged.
        Flexible(
          child: Text(
            AppLocalizations.of(context).reliabilityColorLabel(color.name),
            style: style,
          ),
        ),
      ],
    );
  }
}

/// The colored dot alone, decorative: its label must be shown next to it.
class ReliabilityDot extends StatelessWidget {
  const ReliabilityDot({required this.color, super.key});

  static const size = 12.0;

  final ReliabilityColor color;

  @override
  Widget build(BuildContext context) {
    final colors = ReliabilityColors.of(context);
    final outline = colors.outlineOf(color);
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.colorOf(color),
          shape: BoxShape.circle,
          border: outline == null ? null : Border.all(color: outline),
        ),
      ),
    );
  }
}
