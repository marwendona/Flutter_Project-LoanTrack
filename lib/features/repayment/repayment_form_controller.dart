import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';
import '../../core/money/currency.dart';
import '../../core/money/money.dart';
import '../../core/money/money_formatter.dart';
import '../../core/money/money_parser.dart';
import '../../data/providers.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/services/repayment_validator.dart';

part 'repayment_form_controller.freezed.dart';

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

    /// Remaining amount due of the loan: upper bound of the amount (RG-16).
    required Money remaining,
    required LocalDay repaymentDate,
    @Default('') String amountInput,
    @Default('') String note,

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
        remaining: remaining,
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

/// The repayment sheet of a loan, keyed by the loan as shown when the sheet
/// opens.
final repaymentFormControllerProvider = NotifierProvider.autoDispose
    .family<RepaymentFormController, RepaymentFormState, LoanSummary>(
      RepaymentFormController.new,
    );

/// Edits and saves a new repayment of a loan (US-3.1).
class RepaymentFormController extends Notifier<RepaymentFormState> {
  RepaymentFormController(this._loan);

  final LoanSummary _loan;

  @override
  RepaymentFormState build() {
    final today = LocalDay.today();
    return RepaymentFormState(
      currency: ref.watch(currencyProvider),
      today: today,
      loanDate: _loan.loan.loanDate,
      remaining: _loan.remaining,
      repaymentDate: today,
    );
  }

  void amountChanged(String input) => state = state.copyWith(
    amountInput: input,
    isAmountDirty: true,
    hasSaveFailed: false,
  );

  /// Fills the amount with the remaining amount due (RG-18) and returns the
  /// text put in the field.
  String fillRemaining() {
    final input = MoneyFormatter.formatAmount(state.remaining, state.currency);
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
    state = state.copyWith(isSaving: true, hasSaveFailed: false);
    try {
      await ref
          .read(repaymentRepositoryProvider)
          .add(
            loanId: _loan.loan.id,
            amount: amount,
            repaymentDate: state.repaymentDate,
            note: trimmedNote.isEmpty ? null : trimmedNote,
          );
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
