import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money/money_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/overdue_badge.dart';
import '../../core/widgets/reliability_indicator.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower_summary.dart';
import '../../l10n/generated/app_localizations.dart';
import 'borrower_delete_dialog.dart';
import 'borrower_form_sheet.dart';
import 'borrowers_providers.dart';

/// ECR-02 — Borrowers list (US-1.1), "+" button to add one (US-1.2).
class BorrowersScreen extends ConsumerWidget {
  const BorrowersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filteredSummaries = ref.watch(filteredBorrowersProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navBorrowers),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.borrowerSearchHint,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).updateQuery(value);
              },
            ),
          ),
        ),
      ),
      body: switch (filteredSummaries) {
        [] => EmptyState(
          icon: Icons.people_outline,
          message: l10n.borrowersEmpty,
        ),
        final value => _BorrowersList(summaries: value),
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
    // Name and badge on the first line, reliability on the second (RG-62),
    // active loans and remaining due on the third: the amount moves to its own
    // line rather than overflowing when the system font is enlarged (ENF-08).
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              summary.borrower.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (summary.isOverdue) ...[
            const SizedBox(width: 8),
            const Flexible(child: OverdueBadge()),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: l10n.reliabilityTitle,
            child: ReliabilityIndicator(color: summary.reliability.color),
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 16,
              children: [
                Text(l10n.borrowersActiveLoans(summary.activeLoanCount)),
                Semantics(
                  label: l10n.borrowersRemainingLabel,
                  child: Text(
                    MoneyFormatter.format(summary.remaining, currency),
                    style: textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        tooltip: l10n.moreActionsTooltip,
        onSelected: (action) {
          if (action == 'edit') {
            showBorrowerEditSheet(context, summary.borrower);
          } else if (action == 'delete') {
            showBorrowerDeleteDialog(context, ref, summary);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'edit', child: Text(l10n.borrowerFormEditTitle)),
          PopupMenuItem(
            value: 'delete',
            child: Text(l10n.borrowerDeleteConfirm),
          ),
        ],
      ),
      onTap: () => context.go(AppRoutes.borrowerDetail(summary.borrower.id)),
      onLongPress: () => showBorrowerDeleteDialog(context, ref, summary),
    );
  }
}
