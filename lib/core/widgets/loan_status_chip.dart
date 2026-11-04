import 'package:material_ui/material_ui.dart';

import '../../domain/models/loan_status.dart';
import '../../l10n/generated/app_localizations.dart';
import '../theme/status_colors.dart';

/// Colored label of a loan status (RG-20, RG-23): always text, never color
/// alone.
class LoanStatusChip extends StatelessWidget {
  const LoanStatusChip({required this.status, super.key});

  final LoanStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = StatusColors.of(context);
    final (label, color) = switch (status) {
      LoanOngoing() => (l10n.loanStatusOngoing, colors.ongoing),
      LoanPartiallyRepaid() => (
        l10n.loanStatusPartiallyRepaid,
        colors.partiallyRepaid,
      ),
      LoanRepaid() => (l10n.loanStatusRepaid, colors.repaid),
      LoanOverdue(:final days) => (
        l10n.loanStatusOverdue(days),
        colors.overdue,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: color),
        ),
      ),
    );
  }
}
