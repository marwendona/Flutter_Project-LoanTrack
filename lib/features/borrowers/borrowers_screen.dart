import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money/currency.dart';
import '../../core/money/money_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/overdue_badge.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower_summary.dart';
import '../../l10n/generated/app_localizations.dart';
import 'borrower_form_sheet.dart';
import 'borrowers_providers.dart';

/// ECR-02 — Borrowers list (US-1.1), "+" button to add one (US-1.2).
class BorrowersScreen extends ConsumerWidget {
  const BorrowersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summaries = ref.watch(borrowerSummariesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navBorrowers)),
      body: switch (summaries) {
        AsyncData(:final value) when value.isEmpty => EmptyState(
          icon: Icons.people_outline,
          message: l10n.borrowersEmpty,
        ),
        AsyncData(:final value) => _BorrowersList(summaries: value),
        AsyncError() => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.borrowerAddTooltip,
        onPressed: () => showBorrowerFormSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BorrowersList extends StatelessWidget {
  const _BorrowersList({required this.summaries});

  final List<BorrowerSummary> summaries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // Keeps the last row reachable above the "+" button.
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: summaries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, index) => _BorrowerTile(summary: summaries[index]),
    );
  }
}

class _BorrowerTile extends ConsumerWidget {
  const _BorrowerTile({required this.summary});

  final BorrowerSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final currency = ref.watch(currencyProvider);
    return ListTile(
      title: Text(
        summary.borrower.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(l10n.borrowersActiveLoans(summary.activeLoanCount)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Semantics(
                label: l10n.borrowersRemainingLabel,
                child: Text(
                  MoneyFormatter.format(summary.remaining, currency),
                  style: textTheme.titleMedium,
                ),
              ),
              if (summary.isOverdue) ...[
                const SizedBox(height: 4),
                const OverdueBadge(),
              ],
            ],
          ),
          PopupMenuButton<String>(
            tooltip: l10n.actionCancel,
            onSelected: (action) {
              if (action == 'delete') {
                _showDeleteDialog(context, ref, summary, currency, l10n);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Text(l10n.borrowerDeleteConfirm),
              ),
            ],
          ),
        ],
      ),
      onLongPress: () => _showDeleteDialog(context, ref, summary, currency, l10n),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    BorrowerSummary summary,
    Currency currency,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.borrowerDeleteTitle),
        content: Text(
          l10n.borrowerDeleteMessage(
            summary.loanCount,
            MoneyFormatter.format(summary.remaining, currency),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(borrowerRepositoryProvider).delete(summary.borrower.id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.saveError)),
                  );
                }
              }
            },
            child: Text(l10n.borrowerDeleteConfirm),
          ),
        ],
      ),
    );
  }
}
