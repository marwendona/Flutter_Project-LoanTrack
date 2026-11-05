import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/date/date_formatter.dart';
import '../../core/money/money_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/label_value_row.dart';
import '../../core/widgets/loan_status_chip.dart';
import '../../data/providers.dart';
import '../../domain/models/loan_status.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/models/repayment.dart';
import '../../l10n/generated/app_localizations.dart';
import '../loan/loan_delete_dialog.dart';
import '../repayment/repayment_form_sheet.dart';
import 'loan_detail_providers.dart';

/// ECR-05 — Loan detail: the loan, its status and its repayment history
/// (US-3.2).
class LoanDetailScreen extends ConsumerWidget {
  const LoanDetailScreen({
    super.key,
    required this.borrowerId,
    required this.loanId,
  });

  final int borrowerId;
  final int loanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(loanDetailProvider(loanId));
    // Keeps the previous detail while it is refreshed after a change.
    final detail = detailAsync.hasValue ? detailAsync.value : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loanDetailTitle),
        actions: [
          if (detail != null)
            _LoanMenu(summary: detail.summary, borrowerId: borrowerId),
        ],
      ),
      body: switch (detail) {
        final detail? => _LoanDetailBody(detail: detail),
        null when detailAsync.hasValue => EmptyState(
          icon: Icons.search_off,
          message: l10n.loanNotFound,
        ),
        null when detailAsync.hasError => EmptyState(
          icon: Icons.error_outline,
          message: l10n.loadError,
        ),
        null => const Center(child: CircularProgressIndicator()),
      },
      // Hidden once the loan is fully repaid (ECR-05).
      floatingActionButton: detail == null || detail.summary.remaining.isZero
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showRepaymentFormSheet(context, detail.summary),
              icon: const Icon(Icons.add),
              label: Text(l10n.repaymentAddButton),
            ),
    );
  }
}

/// Menu ⋮ of the loan: edit (ECR-04) or delete (RG-14) it.
class _LoanMenu extends ConsumerWidget {
  const _LoanMenu({required this.summary, required this.borrowerId});

  final LoanSummary summary;
  final int borrowerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loan = summary.loan;
    return PopupMenuButton<_LoanAction>(
      tooltip: l10n.moreActionsTooltip,
      onSelected: (action) async {
        switch (action) {
          case _LoanAction.edit:
            await context.push(AppRoutes.editLoan(loan.borrowerId, loan.id));
          case _LoanAction.delete:
            final deleted = await showLoanDeleteDialog(context, ref, loan);
            if (deleted && context.mounted) {
              context.canPop()
                  ? context.pop()
                  : context.go(AppRoutes.borrowerDetail(borrowerId));
            }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _LoanAction.edit,
          child: Text(l10n.loanFormEditTitle),
        ),
        PopupMenuItem(
          value: _LoanAction.delete,
          child: Text(l10n.loanDeleteAction),
        ),
      ],
    );
  }
}

enum _LoanAction { edit, delete }

class _LoanDetailBody extends StatelessWidget {
  const _LoanDetailBody({required this.detail});

  final LoanDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      // Keeps the last repayment reachable above the "+ Remboursement" button.
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        _LoanInfo(summary: detail.summary, status: detail.status),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            l10n.repaymentHistoryTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (detail.repayments.isEmpty)
          EmptyState(
            icon: Icons.receipt_long_outlined,
            message: l10n.repaymentHistoryEmpty,
          )
        else
          for (final repayment in detail.repayments)
            _RepaymentTile(loan: detail.summary, repayment: repayment),
      ],
    );
  }
}

/// Amount, status, dates, note and repaid / remaining of the loan (RG-20 to
/// RG-23).
class _LoanInfo extends ConsumerWidget {
  const _LoanInfo({required this.summary, required this.status});

  final LoanSummary summary;
  final LoanStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final currency = ref.watch(currencyProvider);
    final loan = summary.loan;
    final promised = loan.promisedReturnDate;
    final note = loan.note;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // Stretched so the Wrap rows span the card width.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  MoneyFormatter.format(loan.amount, currency),
                  style: textTheme.titleLarge,
                ),
                LoanStatusChip(status: status),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.loanLentOn(DateFormatter.format(loan.loanDate))),
            Text(
              l10n.loanPromisedReturn(
                promised != null
                    ? DateFormatter.format(promised)
                    : l10n.loanFormPromisedReturnDateNone,
              ),
            ),
            if (status case LoanRepaid(:final repaidOn?))
              Text(l10n.loanRepaidOn(DateFormatter.format(repaidOn))),
            if (note != null) ...[
              const SizedBox(height: 8),
              Text(note, style: textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            // Ratio for display only: amounts themselves stay integers.
            // Decorative: repaid and remaining are read just below.
            ExcludeSemantics(
              child: LinearProgressIndicator(
                value: summary.repaid.amountMinor / loan.amount.amountMinor,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(
                  l10n.loanRepaidAmount(
                    MoneyFormatter.format(summary.repaid, currency),
                  ),
                ),
                Text(
                  l10n.loanRemainingAmount(
                    MoneyFormatter.format(summary.remaining, currency),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One repayment of the history: actual date, amount and note. A tap opens
/// ECR-05b to edit or delete it (RG-19).
class _RepaymentTile extends ConsumerWidget {
  const _RepaymentTile({required this.loan, required this.repayment});

  final LoanSummary loan;
  final Repayment repayment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final note = repayment.note;
    // Date and amount in the title: the amount moves below the date rather
    // than overflowing when the system font is enlarged (ENF-08).
    return ListTile(
      leading: const Icon(Icons.payments_outlined),
      title: LabelValueRow(
        label: DateFormatter.format(repayment.repaymentDate),
        value: MoneyFormatter.format(repayment.amount, currency),
        valueStyle: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: note == null ? null : Text(note),
      onTap: () => showRepaymentFormSheet(context, loan, existing: repayment),
    );
  }
}
