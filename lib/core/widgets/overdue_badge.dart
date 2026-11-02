import 'package:material_ui/material_ui.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/status_colors.dart';

/// "En retard" label in the overdue status color: always text, never color
/// alone.
class OverdueBadge extends StatelessWidget {
  const OverdueBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final color = StatusColors.of(context).overdue;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          AppLocalizations.of(context).overdueBadge,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ),
    );
  }
}
