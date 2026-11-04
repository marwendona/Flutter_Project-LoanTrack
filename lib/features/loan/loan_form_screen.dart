import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/date/date_formatter.dart';
import '../../core/date/local_day.dart';
import '../../core/money/money_formatter.dart';
import '../../domain/services/loan_validator.dart';
import '../../l10n/generated/app_localizations.dart';
import 'loan_form_controller.dart';

/// ECR-04 — Loan form, creation (US-2.1).
class LoanFormScreen extends ConsumerWidget {
  const LoanFormScreen({super.key, required this.borrowerId});

  final int borrowerId;

  // Bounds of the date pickers; validation itself is done by LoanValidator.
  static final _firstPickerDate = DateTime(2000);
  static final _lastPickerDate = DateTime(2100, 12, 31);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(loanFormControllerProvider);
    final controller = ref.read(loanFormControllerProvider.notifier);

    Future<void> save() async {
      final saved = await controller.save(borrowerId);
      if (saved && context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loanFormNewTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\s]')),
              ],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.loanFormAmount,
                suffixText: state.currency.code,
                errorText: state.isAmountDirty
                    ? _amountErrorText(state, l10n)
                    : null,
              ),
              onChanged: controller.amountChanged,
            ),
            const SizedBox(height: 16),
            _DateField(
              label: l10n.loanFormLoanDate,
              value: state.loanDate,
              errorText: switch (state.loanDateError) {
                LoanDateError.inFuture => l10n.loanDateInFuture,
                null => null,
              },
              onTap: () async {
                final picked = await _pickDate(
                  context,
                  initial: state.loanDate,
                  first: _firstPickerDate,
                  last: _toDateTime(state.today),
                );
                if (picked != null) controller.loanDateChanged(picked);
              },
            ),
            const SizedBox(height: 16),
            _DateField(
              label: l10n.loanFormPromisedReturnDate,
              value: state.promisedReturnDate,
              emptyText: l10n.loanFormPromisedReturnDateNone,
              clearTooltip: l10n.loanFormPromisedReturnDateClear,
              onClear: () => controller.promisedReturnDateChanged(null),
              errorText: switch (state.promisedReturnDateError) {
                PromisedReturnDateError.beforeLoanDate =>
                  l10n.loanPromisedReturnDateBeforeLoanDate,
                null => null,
              },
              onTap: () async {
                final initial = state.promisedReturnDate ?? state.loanDate;
                final picked = await _pickDate(
                  context,
                  initial: initial,
                  first: _toDateTime(
                    initial < state.loanDate ? initial : state.loanDate,
                  ),
                  last: _lastPickerDate,
                );
                if (picked != null) {
                  controller.promisedReturnDateChanged(picked);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              minLines: 1,
              maxLines: 4,
              maxLength: LoanValidator.noteMaxLength,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.loanFormNote,
                errorText: state.isNoteValid
                    ? null
                    : l10n.noteTooLong(LoanValidator.noteMaxLength),
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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

  static String? _amountErrorText(LoanFormState state, AppLocalizations l10n) =>
      switch (state.amountError) {
        LoanAmountError.required => l10n.loanAmountRequired,
        LoanAmountError.invalidFormat => l10n.loanAmountInvalid(
          state.currency.decimals,
        ),
        LoanAmountError.notPositive => l10n.loanAmountNotPositive,
        LoanAmountError.tooLarge => l10n.loanAmountTooLarge(
          MoneyFormatter.format(
            LoanValidator.maxAmount(state.currency),
            state.currency,
          ),
        ),
        null => null,
      };

  static Future<LocalDay?> _pickDate(
    BuildContext context, {
    required LocalDay initial,
    required DateTime first,
    required DateTime last,
  }) async {
    var initialDate = _toDateTime(initial);
    if (initialDate.isBefore(first)) initialDate = first;
    if (initialDate.isAfter(last)) initialDate = last;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: first,
      lastDate: last,
    );
    return picked == null ? null : LocalDay.fromDateTime(picked);
  }

  static DateTime _toDateTime(LocalDay day) =>
      DateTime(day.year, day.month, day.day);
}

/// A read-only field showing a day; tapping it opens a date picker.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.errorText,
    this.emptyText,
    this.onClear,
    this.clearTooltip,
  });

  final String label;
  final LocalDay? value;
  final VoidCallback onTap;
  final String? errorText;

  /// Shown when [value] is null.
  final String? emptyText;

  /// When set, a clear button is shown while [value] is not null.
  final VoidCallback? onClear;
  final String? clearTooltip;

  @override
  Widget build(BuildContext context) {
    final day = value;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          suffixIcon: day != null && onClear != null
              ? IconButton(
                  tooltip: clearTooltip,
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
        ),
        child: Text(day != null ? DateFormatter.format(day) : emptyText ?? ''),
      ),
    );
  }
}
