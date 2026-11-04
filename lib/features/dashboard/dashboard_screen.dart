import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money/money_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/status_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/overdue_badge.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower_summary.dart';
import '../../domain/models/borrower_summary_filter.dart';
import '../../domain/models/global_totals.dart';
import '../../l10n/generated/app_localizations.dart';
import '../borrowers/borrower_form_sheet.dart';
import '../borrowers/borrowers_providers.dart';
import 'dashboard_providers.dart';

/// ECR-01 — Dashboard (home): global totals (US-4.1) and totals per borrower
/// (US-4.2) with quick filters (US-4.3).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final totalsAsync = ref.watch(globalTotalsProvider);
    // Keeps the previous totals while they are refreshed after a change.
    final totals = totalsAsync.hasValue ? totalsAsync.value : null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDashboard)),
      body: switch (totals) {
        final totals? when totals.loanCount == 0 => const _EmptyDashboard(),
        final totals? => _DashboardBody(totals: totals),
        null when totalsAsync.hasError => EmptyState(
          icon: Icons.error_outline,
          message: l10n.loadError,
        ),
        null => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  const _EmptyDashboard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              message: l10n.dashboardEmpty,
            ),
            FilledButton.icon(
              onPressed: () => showBorrowerFormSheet(context),
              icon: const Icon(Icons.person_add_outlined),
              label: Text(l10n.dashboardAddBorrower),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.totals});

  final GlobalTotals totals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasBorrowers =
        ref.watch(borrowerSummariesProvider).value?.isNotEmpty ?? false;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _RemainingCard(totals: totals),
        _IndicatorsCard(totals: totals),
        if (hasBorrowers) const _ByBorrowerSection(),
      ],
    );
  }
}

/// Highlighted card: amount still to be received (RG-31).
class _RemainingCard extends ConsumerWidget {
  const _RemainingCard({required this.totals});

  final GlobalTotals totals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currency = ref.watch(currencyProvider);
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardRemainingTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              MoneyFormatter.format(totals.remaining, currency),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.dashboardBorrowersWithRemaining(
                totals.borrowersWithRemainingCount,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Total lent, total repaid, repayment rate (RG-32) and overdue loans (RG-31).
class _IndicatorsCard extends ConsumerWidget {
  const _IndicatorsCard({required this.totals});

  final GlobalTotals totals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _IndicatorRow(
              label: l10n.borrowerDetailTotalLent,
              value: MoneyFormatter.format(totals.totalLent, currency),
            ),
            const SizedBox(height: 8),
            _IndicatorRow(
              label: l10n.borrowerDetailTotalRepaid,
              value: MoneyFormatter.format(totals.totalRepaid, currency),
            ),
            const SizedBox(height: 16),
            _IndicatorRow(
              label: l10n.dashboardRepaymentRate,
              value: l10n.dashboardRepaymentRateValue(
                totals.repaymentRatePercent,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: totals.repaymentRatio),
            const Divider(height: 32),
            _OverdueRow(totals: totals),
          ],
        ),
      ),
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({
    required this.label,
    required this.value,
    this.color,
    this.style,
  });

  final String label;
  final String value;
  final Color? color;

  /// Defaults to `bodyLarge`.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = (this.style ?? Theme.of(context).textTheme.bodyLarge)
        ?.copyWith(color: color);
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

/// "Par emprunteur" list: totals of each borrower (RG-30, US-4.2), filtered
/// by *Tous* / *Avec reste dû* / *En retard* (US-4.3).
class _ByBorrowerSection extends ConsumerWidget {
  const _ByBorrowerSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Already sorted by remaining due then name (RG-04).
    final summaries = ref.watch(dashboardBorrowersProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.dashboardByBorrowerTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: _FilterButtons(),
        ),
        if (summaries.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.dashboardFilterNoMatch,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          Card(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (index, summary) in summaries.indexed) ...[
                  if (index > 0) const Divider(height: 1),
                  _BorrowerTotalsTile(summary: summary),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// *Tous* / *Avec reste dû* / *En retard* (US-4.3).
class _FilterButtons extends ConsumerWidget {
  const _FilterButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(dashboardFilterProvider);
    return SegmentedButton<BorrowerSummaryFilter>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: BorrowerSummaryFilter.all,
          label: Text(l10n.dashboardFilterAll),
        ),
        ButtonSegment(
          value: BorrowerSummaryFilter.withRemaining,
          label: Text(l10n.dashboardFilterWithRemaining),
        ),
        ButtonSegment(
          value: BorrowerSummaryFilter.overdue,
          label: Text(l10n.dashboardFilterOverdue),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) =>
          ref.read(dashboardFilterProvider.notifier).select(selection.single),
    );
  }
}

/// Name, total lent, total repaid, remaining due and overdue badge of a
/// borrower; tap opens its detail (ECR-03).
class _BorrowerTotalsTile extends ConsumerWidget {
  const _BorrowerTotalsTile({required this.summary});

  final BorrowerSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currency = ref.watch(currencyProvider);
    final amountStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return InkWell(
      onTap: () => context.go(AppRoutes.borrowerDetail(summary.borrower.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    summary.borrower.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                if (summary.isOverdue) ...[
                  const SizedBox(width: 8),
                  const OverdueBadge(),
                ],
              ],
            ),
            const SizedBox(height: 4),
            _IndicatorRow(
              label: l10n.borrowerDetailTotalLent,
              value: MoneyFormatter.format(summary.totalLent, currency),
              style: amountStyle,
            ),
            _IndicatorRow(
              label: l10n.borrowerDetailTotalRepaid,
              value: MoneyFormatter.format(summary.totalRepaid, currency),
              style: amountStyle,
            ),
            _IndicatorRow(
              label: l10n.borrowersRemainingLabel,
              value: MoneyFormatter.format(summary.remaining, currency),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Number and remaining amount of the overdue loans, in red when > 0.
class _OverdueRow extends ConsumerWidget {
  const _OverdueRow({required this.totals});

  final GlobalTotals totals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    final hasOverdue = totals.overdueLoanCount > 0;
    final color = hasOverdue ? StatusColors.of(context).overdue : null;
    return Row(
      children: [
        Icon(
          hasOverdue ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _IndicatorRow(
            label: l10n.dashboardOverdueLoans(totals.overdueLoanCount),
            value: MoneyFormatter.format(totals.overdueAmount, currency),
            color: color,
          ),
        ),
      ],
    );
  }
}
