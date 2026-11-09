import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money/money_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/reliability_indicator.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower_summary.dart';
import '../../domain/services/reliability_grouping.dart';
import '../../l10n/generated/app_localizations.dart';
import 'borrowers_by_color_providers.dart';
import 'reliability_legend_dialog.dart';

/// ECR-07 — Borrowers grouped by reliability color (US-7.3).
class BorrowersByColorScreen extends ConsumerWidget {
  const BorrowersByColorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final groups = ref.watch(borrowersByColorProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.borrowersByColorTitle),
        actions: [
          IconButton(
            tooltip: l10n.reliabilityLegendTitle,
            icon: const Icon(Icons.help_outline),
            onPressed: () => showReliabilityLegendDialog(context),
          ),
        ],
      ),
      body: switch (groups) {
        [] => EmptyState(
          icon: Icons.people_outline,
          message: l10n.borrowersByColorEmpty,
        ),
        final groups => ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            for (final group in groups) ...[
              _SectionHeader(group: group),
              for (final summary in group.borrowers)
                _BorrowerTile(summary: summary),
            ],
          ],
        ),
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.group});

  final ReliabilityGroup group;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: MergeSemantics(
        child: Container(
          color: theme.colorScheme.surfaceContainerHigh,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // The count moves to its own line rather than overflowing when the
          // system font is enlarged (ENF-08).
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            children: [
              ReliabilityIndicator(
                color: group.color,
                style: theme.textTheme.titleSmall,
              ),
              Text(
                l10n.borrowersByColorCount(group.borrowers.length),
                style: theme.textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BorrowerTile extends ConsumerWidget {
  const _BorrowerTile({required this.summary});

  final BorrowerSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currency = ref.watch(currencyProvider);
    final reliability = summary.reliability;
    // The amount moves to its own line rather than overflowing when the
    // system font is enlarged (ENF-08).
    return ListTile(
      title: Text(
        summary.borrower.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 16,
          children: [
            Text(
              reliability.lateLoanCount == 0
                  ? l10n.reliabilityNoDelay
                  : l10n.reliabilityDelayDetail(
                      reliability.lateLoanCount,
                      reliability.longDelayCount,
                    ),
            ),
            Semantics(
              label: l10n.borrowersRemainingLabel,
              child: Text(
                MoneyFormatter.format(summary.remaining, currency),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
      // Pushed so that "back" returns to ECR-07.
      onTap: () => context.push(AppRoutes.borrowerDetail(summary.borrower.id)),
    );
  }
}
