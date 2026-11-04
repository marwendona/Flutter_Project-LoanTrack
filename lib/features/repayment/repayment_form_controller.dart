import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';
import '../../core/money/currency.dart';
import '../../core/money/money.dart';
import '../../core/money/money_formatter.dart';
import '../../core/money/money_parser.dart';
import '../../data/providers.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/models/repayment.dart';
import '../../domain/services/repayment_validator.dart';

part 'repayment_form_controller.freezed.dart';

/// What the repayment sheet (ECR-05b) edits: a new repayment of [loan] when
/// [existing] is null (US-3.1), otherwise that existing repayment (US-3.3).
/// [loan] is the loan as shown when the sheet opens.
typedef RepaymentFormTarget = ({LoanSummary loan, Repayment? existing});

/// State of the repayment sheet (ECR-05b). Errors are derived from the
/// fields, never stored.
@freezed
abstract class RepaymentFormState with _$RepaymentFormState {
  const factory RepaymentFormState({
    required Currency currency,

    /// Today, captured when the sheet opens (RG-17).
    required LocalDay today,

    /// Date of the repaid loan: lower bound of the repayment date (RG-17).
    required LocalDay loanDate,

    /// Upper bound of the amount (RG-16): the remaining amount due of the
    /// loan, plus the initial amount of the edited repayment.
    required Money maxAmount,
    required LocalDay repaymentDate,
    @Default('') String amountInput,
    @Default('') String note,

    /// The sheet edits an existing repayment.
    @Default(false) bool isEditing,

    /// The amount was edited: its error can be shown.
    @Default(false) bool isAmountDirty,
    @Default(false) bool isSaving,

    /// The last save failed for an unexpected reason.
    @Default(false) bool hasSaveFailed,
  }) = _RepaymentFormState;

  const RepaymentFormState._();

  RepaymentAmountError? get amountError =>
      RepaymentValidator.validateAmountInput(
        amountInput,
        currency,
        remaining: maxAmount,
      );

  RepaymentDateError? get repaymentDateError =>
      RepaymentValidator.validateRepaymentDate(
        repaymentDate,
        loanDate: loanDate,
        today: today,
      );

  bool get isNoteValid => RepaymentValidator.isNoteValid(note);

  bool get isValid =>
      amountError == null && repaymentDateError == null && isNoteValid;

  /// "Enregistrer" is enabled only when the form is valid.
  bool get canSave => isValid && !isSaving;
}

final repaymentFormControllerProvider = NotifierProvider.autoDispose
    .family<RepaymentFormController, RepaymentFormState, RepaymentFormTarget>(
      RepaymentFormController.new,
    );

/// Edits and saves a new repayment of a loan (US-3.1) or an existing one
/// (US-3.3).
class RepaymentFormController extends Notifier<RepaymentFormState> {
  RepaymentFormController(this._target);

  final RepaymentFormTarget _target;

  @override
  RepaymentFormState build() {
    final today = LocalDay.today();
    final currency = ref.watch(currencyProvider);
    final loan = _target.loan;
    final existing = _target.existing;
    if (existing == null) {
      return RepaymentFormState(
        currency: currency,
        today: today,
        loanDate: loan.loan.loanDate,
        maxAmount: loan.remaining,
        repaymentDate: today,
      );
    }
    return RepaymentFormState(
      currency: currency,
      today: today,
      loanDate: loan.loan.loanDate,
      maxAmount: loan.remaining + existing.amount,
      repaymentDate: existing.repaymentDate,
      amountInput: MoneyFormatter.formatAmount(existing.amount, currency),
      note: existing.note ?? '',
      isEditing: true,
      // Pre-filled: errors are shown as soon as the amount is invalid.
      isAmountDirty: true,
    );
  }

  void amountChanged(String input) => state = state.copyWith(
    amountInput: input,
    isAmountDirty: true,
    hasSaveFailed: false,
  );

  /// Fills the amount with the maximum amount, which repays the loan in full
  /// (RG-18), and returns the text put in the field.
  String fillRemaining() {
    final input = MoneyFormatter.formatAmount(state.maxAmount, state.currency);
    amountChanged(input);
    return input;
  }

  void repaymentDateChanged(LocalDay date) =>
      state = state.copyWith(repaymentDate: date, hasSaveFailed: false);

  void noteChanged(String note) =>
      state = state.copyWith(note: note, hasSaveFailed: false);

  /// Returns true if the repayment was saved.
  Future<bool> save() async {
    if (!state.canSave) {
      state = state.copyWith(isAmountDirty: true);
      return false;
    }
    final amount = MoneyParser.tryParse(state.amountInput, state.currency)!;
    final trimmedNote = state.note.trim();
    final note = trimmedNote.isEmpty ? null : trimmedNote;
    state = state.copyWith(isSaving: true, hasSaveFailed: false);
    final repository = ref.read(repaymentRepositoryProvider);
    try {
      final existing = _target.existing;
      if (existing == null) {
        await repository.add(
          loanId: _target.loan.loan.id,
          amount: amount,
          repaymentDate: state.repaymentDate,
          note: note,
        );
      } else {
        await repository.update(
          existing.copyWith(
            amount: amount,
            repaymentDate: state.repaymentDate,
            note: note,
          ),
        );
      }
      if (ref.mounted) state = state.copyWith(isSaving: false);
      return true;
    } on Exception {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false, hasSaveFailed: true);
      }
      return false;
    }
  }
}
