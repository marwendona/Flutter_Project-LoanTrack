import 'package:material_ui/material_ui.dart';

import '../../core/widgets/reliability_indicator.dart';
import '../../domain/models/reliability_color.dart';
import '../../l10n/generated/app_localizations.dart';

/// "Signification des couleurs" dialog: the RG-62 table in plain words.
Future<void> showReliabilityLegendDialog(BuildContext context) =>
    showDialog<void>(
      context: context,
      builder: (_) => const ReliabilityLegendDialog(),
    );

class ReliabilityLegendDialog extends StatelessWidget {
  const ReliabilityLegendDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text(l10n.reliabilityLegendTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final color in ReliabilityColor.values)
              _LegendEntry(color: color),
            Text(l10n.reliabilityLegendFootnote, style: textTheme.bodySmall),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionClose),
        ),
      ],
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.color});

  final ReliabilityColor color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      // Label and condition read together by TalkBack.
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReliabilityIndicator(color: color, style: textTheme.titleSmall),
            Padding(
              padding: const EdgeInsets.only(left: ReliabilityDot.size + 8),
              child: Text(
                l10n.reliabilityColorCondition(color.name),
                style: textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
