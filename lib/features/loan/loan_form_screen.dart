import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/date/date_formatter.dart';
import '../../core/date/local_day.dart';
import '../../core/money/money_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/providers.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/services/loan_validator.dart';
import '../../l10n/generated/app_localizations.dart';
import 'loan_form_controller.dart';

/// The loan edited by ECR-04, read once when the form opens; null if it does
/// not exist.
final editedLoanProvider = FutureProvider.autoDispose.family<LoanSummary?, int>(
  (ref, loanId) => ref.watch(loanRepositoryProvider).getSummaryById(loanId),
);

/// ECR-04 — Loan form: creation of a loan of [borrowerId] (US-2.1), or
/// modification of the loan [loanId] when set (US-2.4).
class LoanFormScreen extends ConsumerWidget {
  const LoanFormScreen({super.key, required this.borrowerId, this.loanId});

  final int borrowerId;
  final int? loanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loanId = this.loanId;
    if (loanId == null) {
      return _LoanFormScaffold(
        title: l10n.loanFormNewTitle,
        body: _LoanForm(target: (borrowerId: borrowerId, existing: null)),
      );
    }
    final edited = ref.watch(editedLoanProvider(loanId));
    return _LoanFormScaffold(
      title: l10n.loanFormEditTitle,
      body: switch (edited) {
        AsyncData(value: final summary?) => _LoanForm(
          target: (borrowerId: summary.loan.borrowerId, existing: summary),
        ),
        AsyncData() => EmptyState(
          icon: Icons.search_off_outlined,
          message: l10n.loanNotFound,
        ),
        AsyncError() => EmptyState(
          icon: Icons.error_outline,
          message: l10n.loadError,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _LoanFormScaffold extends StatelessWidget {
  const _LoanFormScaffold({required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: SafeArea(child: body),
  );
}

class _LoanForm extends ConsumerWidget {
  const _LoanForm({required this.target});

  final LoanFormTarget target;

  // Bounds of the date pickers; validation itself is done by LoanValidator.
  static final _firstPickerDate = DateTime(2000);
  static final _lastPickerDate = DateTime(2100, 12, 31);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = loanFormControllerProvider(target);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    Future<void> save() async {
      final saved = await controller.save();
      if (saved && context.mounted) Navigator.of(context).pop();
    }

    final firstRepayment = state.firstRepaymentDate;
    final lastLoanDate = firstRepayment != null && firstRepayment < state.today
        ? firstRepayment
        : state.today;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        TextFormField(
          initialValue: state.amountInput,
          autofocus: !state.isEditing,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            LoanDateError.afterFirstRepayment =>
              l10n.loanDateAfterFirstRepayment(
                DateFormatter.format(firstRepayment!),
              ),
            null => null,
          },
          onTap: () async {
            final picked = await _pickDate(
              context,
              initial: state.loanDate,
              first: _firstPickerDate,
              last: _toDateTime(lastLoanDate),
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
        TextFormField(
          initialValue: state.note,
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
        LoanAmountError.belowRepaid => l10n.loanAmountBelowRepaid(
          MoneyFormatter.format(state.repaid, state.currency),
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
