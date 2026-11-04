import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money/money_formatter.dart';
import '../../core/theme/status_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/providers.dart';
import '../../domain/models/global_totals.dart';
import '../../l10n/generated/app_localizations.dart';
import '../borrowers/borrower_form_sheet.dart';
import 'dashboard_providers.dart';

/// ECR-01 — Dashboard (home): global totals (US-4.1).
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

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.totals});

  final GlobalTotals totals;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _RemainingCard(totals: totals),
        _IndicatorsCard(totals: totals),
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
  const _IndicatorRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(color: color);
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
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
