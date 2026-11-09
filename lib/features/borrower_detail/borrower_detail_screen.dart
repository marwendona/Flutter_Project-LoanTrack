import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/date/date_formatter.dart';
import '../../core/money/money_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/label_value_row.dart';
import '../../core/widgets/loan_status_chip.dart';
import '../../core/widgets/reliability_indicator.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower.dart';
import '../../domain/models/borrower_reliability.dart';
import '../../domain/models/borrower_summary.dart';
import '../../domain/models/loan_status.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/models/reliability_color.dart';
import '../../l10n/generated/app_localizations.dart';
import '../borrowers/borrower_delete_dialog.dart';
import '../borrowers/borrower_form_sheet.dart';
import '../loan/loan_delete_dialog.dart';
import '../repayment/repayment_form_sheet.dart';
import 'borrower_detail_providers.dart';

/// ECR-03 — Borrower detail: contact, totals and loans (US-2.2).
class BorrowerDetailScreen extends ConsumerWidget {
  const BorrowerDetailScreen({super.key, required this.borrowerId});

  final int borrowerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(borrowerDetailProvider(borrowerId));
    // Keeps the previous detail while it is refreshed after a change.
    final detail = detailAsync.hasValue ? detailAsync.value : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(detail?.summary.borrower.name ?? ''),
        actions: [if (detail != null) _BorrowerMenu(summary: detail.summary)],
      ),
      body: switch (detail) {
        final detail? => _BorrowerDetailBody(detail: detail),
        null when detailAsync.hasValue => EmptyState(
          icon: Icons.person_off_outlined,
          message: l10n.borrowerDetailNotFound,
        ),
        null when detailAsync.hasError => EmptyState(
          icon: Icons.error_outline,
          message: l10n.loadError,
        ),
        null => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: detail == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.newLoan(borrowerId)),
              icon: const Icon(Icons.add),
              label: Text(l10n.loanAddButton),
            ),
    );
  }
}

class _BorrowerMenu extends ConsumerWidget {
  const _BorrowerMenu({required this.summary});

  final BorrowerSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<_BorrowerAction>(
      tooltip: l10n.moreActionsTooltip,
      onSelected: (action) async {
        switch (action) {
          case _BorrowerAction.edit:
            await showBorrowerEditSheet(context, summary.borrower);
          case _BorrowerAction.delete:
            final deleted = await showBorrowerDeleteDialog(
              context,
              ref,
              summary,
            );
            if (deleted && context.mounted) {
              context.canPop()
                  ? context.pop()
                  : context.go(AppRoutes.borrowers);
            }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _BorrowerAction.edit,
          child: Text(l10n.borrowerFormEditTitle),
        ),
        PopupMenuItem(
          value: _BorrowerAction.delete,
          child: Text(l10n.borrowerDeleteConfirm),
        ),
      ],
    );
  }
}

enum _BorrowerAction { edit, delete }

/// Menu ⋮ of a loan card: add a repayment (ECR-05b, US-3.1) unless the loan is
/// repaid, edit (ECR-04) or delete (RG-14) the loan (US-2.4).
class _LoanMenu extends ConsumerWidget {
  const _LoanMenu({required this.summary});

  final LoanSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loan = summary.loan;
    return PopupMenuButton<_LoanAction>(
      tooltip: l10n.moreActionsTooltip,
      onSelected: (action) async {
        switch (action) {
          case _LoanAction.addRepayment:
            await showRepaymentFormSheet(context, summary);
          case _LoanAction.edit:
            await context.push(AppRoutes.editLoan(loan.borrowerId, loan.id));
          case _LoanAction.delete:
            await showLoanDeleteDialog(context, ref, loan);
        }
      },
      itemBuilder: (context) => [
        if (!summary.remaining.isZero)
          PopupMenuItem(
            value: _LoanAction.addRepayment,
            child: Text(l10n.repaymentAddAction),
          ),
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

enum _LoanAction { addRepayment, edit, delete }

class _BorrowerDetailBody extends StatelessWidget {
  const _BorrowerDetailBody({required this.detail});

  final BorrowerDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final borrower = detail.summary.borrower;
    return ListView(
      // Keeps the last card reachable above the "+ Prêt" button.
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        _Contact(borrower: borrower),
        _Totals(summary: detail.summary),
        _Reliability(reliability: detail.summary.reliability),
        if (detail.loans.isEmpty)
          EmptyState(
            icon: Icons.payments_outlined,
            message: l10n.borrowerDetailLoansEmpty,
          )
        else
          for (final loan in detail.loans) _LoanCard(item: loan),
      ],
    );
  }
}

/// Phone (tap opens the dialer) and note of the borrower, when set.
class _Contact extends StatelessWidget {
  const _Contact({required this.borrower});

  final Borrower borrower;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phone = borrower.phone;
    final note = borrower.note;
    return Column(
      children: [
        if (phone != null)
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: Text(phone),
            trailing: Tooltip(
              message: l10n.borrowerDetailCallTooltip,
              child: const Icon(Icons.call),
            ),
            onTap: () => _openDialer(context, phone),
          ),
        if (note != null)
          ListTile(
            leading: const Icon(Icons.notes_outlined),
            title: Text(note),
          ),
      ],
    );
  }

  /// Opens the phone dialer with the number pre-filled: nothing is called
  /// without the user confirming, so no permission is needed.
  static Future<void> _openDialer(BuildContext context, String phone) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context).borrowerDetailCallError;
    var opened = false;
    try {
      opened = await launchUrl(Uri(scheme: 'tel', path: phone));
    } catch (_) {
      opened = false;
    }
    if (!opened) messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Total lent, total repaid and remaining due of the borrower (RG-30).
class _Totals extends ConsumerWidget {
  const _Totals({required this.summary});

  final BorrowerSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _TotalRow(
              label: l10n.borrowerDetailTotalLent,
              value: MoneyFormatter.format(summary.totalLent, currency),
            ),
            const SizedBox(height: 8),
            _TotalRow(
              label: l10n.borrowerDetailTotalRepaid,
              value: MoneyFormatter.format(summary.totalRepaid, currency),
            ),
            const Divider(height: 24),
            _TotalRow(
              label: l10n.borrowersRemainingLabel,
              value: MoneyFormatter.format(summary.remaining, currency),
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = emphasized ? textTheme.titleMedium : textTheme.bodyLarge;
    return LabelValueRow(label: label, value: value, style: style);
  }
}

/// Reliability color with its label and, when the borrower has delays, the
/// number of late loans N and of long delays L (RG-62).
class _Reliability extends StatelessWidget {
  const _Reliability({required this.reliability});

  final BorrowerReliability reliability;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final color = reliability.color;
    final showDetail =
        color != ReliabilityColor.green &&
        color != ReliabilityColor.notEvaluated;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.reliabilityTitle, style: textTheme.titleSmall),
            const SizedBox(height: 8),
            ReliabilityIndicator(color: color, style: textTheme.bodyLarge),
            if (showDetail) ...[
              const SizedBox(height: 4),
              Text(
                l10n.reliabilityDelayDetail(
                  reliability.lateLoanCount,
                  reliability.longDelayCount,
                ),
                style: textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// One loan: amount, dates, repaid / remaining with a progress bar and status
/// (RG-20 to RG-23).
class _LoanCard extends ConsumerWidget {
  const _LoanCard({required this.item});

  final LoanItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final currency = ref.watch(currencyProvider);
    final summary = item.summary;
    final loan = summary.loan;
    final promised = loan.promisedReturnDate;
    final status = item.status;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      clipBehavior: Clip.antiAlias,
      // Tap opens the loan detail with its repayments (ECR-05, US-3.2).
      child: InkWell(
        onTap: () =>
            context.push(AppRoutes.loanDetail(loan.borrowerId, loan.id)),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Its label wraps rather than pushing the menu out.
                      Flexible(child: LoanStatusChip(status: status)),
                      _LoanMenu(summary: summary),
                    ],
                  ),
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
      ),
    );
  }
}
