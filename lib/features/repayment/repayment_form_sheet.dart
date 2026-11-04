import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/date/date_formatter.dart';
import '../../core/money/money_formatter.dart';
import '../../core/widgets/date_field.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/models/repayment.dart';
import '../../domain/services/repayment_validator.dart';
import '../../l10n/generated/app_localizations.dart';
import 'repayment_delete_dialog.dart';
import 'repayment_form_controller.dart';

/// Opens the repayment sheet (ECR-05b) of [loan]: a new repayment (US-3.1),
/// or the [existing] one to edit or delete (US-3.3).
Future<void> showRepaymentFormSheet(
  BuildContext context,
  LoanSummary loan, {
  Repayment? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => RepaymentFormSheet(loan: loan, existing: existing),
  );
}

/// ECR-05b — Repayment entry: amount, actual date and note, with a reminder
/// of the remaining (or maximum) amount and a "Totalité" shortcut (RG-16 to
/// RG-18). In edition, the repayment can also be deleted (RG-19).
class RepaymentFormSheet extends ConsumerStatefulWidget {
  const RepaymentFormSheet({super.key, required this.loan, this.existing});

  final LoanSummary loan;
  final Repayment? existing;

  @override
  ConsumerState<RepaymentFormSheet> createState() => _RepaymentFormSheetState();
}

class _RepaymentFormSheetState extends ConsumerState<RepaymentFormSheet> {
  // Needed so that "Totalité" can fill the field.
  late final _amount = TextEditingController(
    text: ref.read(_provider).amountInput,
  );
  late final _note = TextEditingController(text: ref.read(_provider).note);

  late final _provider = repaymentFormControllerProvider((
    loan: widget.loan,
    existing: widget.existing,
  ));

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(_provider);
    final controller = ref.read(_provider.notifier);
    final existing = widget.existing;

    Future<void> save() async {
      final saved = await controller.save();
      if (saved && context.mounted) Navigator.of(context).pop();
    }

    Future<void> delete(Repayment repayment) async {
      final deleted = await showRepaymentDeleteDialog(context, ref, repayment);
      if (deleted && context.mounted) Navigator.of(context).pop();
    }

    final maxAmount = MoneyFormatter.format(state.maxAmount, state.currency);
    return Padding(
      // Keeps the fields above the keyboard.
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              state.isEditing
                  ? l10n.repaymentFormEditTitle
                  : l10n.repaymentFormNewTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.isEditing
                  ? l10n.repaymentFormMaxAmount(maxAmount)
                  : l10n.loanRemainingAmount(maxAmount),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _amount,
                    autofocus: !state.isEditing,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\s]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.repaymentFormAmount,
                      suffixText: state.currency.code,
                      errorText: state.isAmountDirty
                          ? _amountErrorText(state, l10n)
                          : null,
                      errorMaxLines: 2,
                    ),
                    onChanged: controller.amountChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton(
                    onPressed: () {
                      _amount.text = controller.fillRemaining();
                    },
                    child: Text(l10n.repaymentFormFullAmount),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DateField(
              label: l10n.repaymentFormDate,
              value: state.repaymentDate,
              errorText: switch (state.repaymentDateError) {
                RepaymentDateError.beforeLoanDate =>
                  l10n.repaymentDateBeforeLoanDate(
                    DateFormatter.format(state.loanDate),
                  ),
                RepaymentDateError.inFuture => l10n.repaymentDateInFuture,
                null => null,
              },
              onTap: () async {
                final picked = await DateField.pick(
                  context,
                  initial: state.repaymentDate,
                  first: DateField.toDateTime(state.loanDate),
                  last: DateField.toDateTime(state.today),
                );
                if (picked != null) controller.repaymentDateChanged(picked);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _note,
              minLines: 1,
              maxLines: 3,
              maxLength: RepaymentValidator.noteMaxLength,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.repaymentFormNote,
                errorText: state.isNoteValid
                    ? null
                    : l10n.noteTooLong(RepaymentValidator.noteMaxLength),
              ),
              onChanged: controller.noteChanged,
            ),
            if (state.hasSaveFailed) ...[
              const SizedBox(height: 8),
              Text(
                l10n.saveError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (existing != null)
                  TextButton(
                    onPressed: state.isSaving ? null : () => delete(existing),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: Text(l10n.repaymentDeleteConfirm),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.actionCancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: state.canSave ? save : null,
                  child: Text(l10n.actionSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String? _amountErrorText(
    RepaymentFormState state,
    AppLocalizations l10n,
  ) {
    final maxAmount = MoneyFormatter.format(state.maxAmount, state.currency);
    return switch (state.amountError) {
      RepaymentAmountError.required => l10n.loanAmountRequired,
      RepaymentAmountError.invalidFormat => l10n.loanAmountInvalid(
        state.currency.decimals,
      ),
      RepaymentAmountError.notPositive => l10n.loanAmountNotPositive,
      RepaymentAmountError.exceedsRemaining =>
        state.isEditing
            ? l10n.repaymentAmountExceedsMax(maxAmount)
            : l10n.repaymentAmountExceedsRemaining(maxAmount),
      null => null,
    };
  }
}
