import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';
import '../../core/money/currency.dart';
import '../../core/money/money_parser.dart';
import '../../data/providers.dart';
import '../../domain/services/loan_validator.dart';

part 'loan_form_controller.freezed.dart';

/// State of the "Nouveau prêt" form (ECR-04). Errors are derived from the
/// fields, never stored.
@freezed
abstract class LoanFormState with _$LoanFormState {
  const factory LoanFormState({
    required Currency currency,

    /// Today, captured when the form opens (RG-11).
    required LocalDay today,
    required LocalDay loanDate,
    LocalDay? promisedReturnDate,
    @Default('') String amountInput,
    @Default('') String note,

    /// The amount was edited: its error can be shown.
    @Default(false) bool isAmountDirty,
    @Default(false) bool isSaving,

    /// The last save failed for an unexpected reason.
    @Default(false) bool hasSaveFailed,
  }) = _LoanFormState;

  const LoanFormState._();

  LoanAmountError? get amountError =>
      LoanValidator.validateAmountInput(amountInput, currency);

  LoanDateError? get loanDateError =>
      LoanValidator.validateLoanDate(loanDate, today);

  PromisedReturnDateError? get promisedReturnDateError =>
      LoanValidator.validatePromisedReturnDate(promisedReturnDate, loanDate);

  bool get isNoteValid => LoanValidator.isNoteValid(note);

  bool get isValid =>
      amountError == null &&
      loanDateError == null &&
      promisedReturnDateError == null &&
      isNoteValid;

  /// "Enregistrer" is enabled only when the form is valid (ECR-04).
  bool get canSave => isValid && !isSaving;
}

final loanFormControllerProvider =
    NotifierProvider.autoDispose<LoanFormController, LoanFormState>(
      LoanFormController.new,
    );

/// Edits and saves a new loan (US-2.1).
class LoanFormController extends Notifier<LoanFormState> {
  @override
  LoanFormState build() {
    final today = LocalDay.today();
    return LoanFormState(
      currency: ref.watch(currencyProvider),
      today: today,
      loanDate: today,
    );
  }

  void amountChanged(String input) => state = state.copyWith(
    amountInput: input,
    isAmountDirty: true,
    hasSaveFailed: false,
  );

  void loanDateChanged(LocalDay date) =>
      state = state.copyWith(loanDate: date, hasSaveFailed: false);

  void promisedReturnDateChanged(LocalDay? date) =>
      state = state.copyWith(promisedReturnDate: date, hasSaveFailed: false);

  void noteChanged(String note) =>
      state = state.copyWith(note: note, hasSaveFailed: false);

  /// Returns true if the loan was saved for [borrowerId].
  Future<bool> save(int borrowerId) async {
    if (!state.canSave) {
      state = state.copyWith(isAmountDirty: true);
      return false;
    }
    final amount = MoneyParser.tryParse(state.amountInput, state.currency)!;
    final note = state.note.trim();
    state = state.copyWith(isSaving: true, hasSaveFailed: false);
    try {
      await ref
          .read(loanRepositoryProvider)
          .add(
            borrowerId: borrowerId,
            amount: amount,
            loanDate: state.loanDate,
            promisedReturnDate: state.promisedReturnDate,
            note: note.isEmpty ? null : note,
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
