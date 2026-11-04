import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';
import '../../core/money/currency.dart';
import '../../core/money/money.dart';
import '../../core/money/money_formatter.dart';
import '../../core/money/money_parser.dart';
import '../../data/providers.dart';
import '../../domain/models/loan_summary.dart';
import '../../domain/services/loan_validator.dart';

part 'loan_form_controller.freezed.dart';

/// What the loan form (ECR-04) edits: a new loan of [borrowerId] when
/// [existing] is null (US-2.1), otherwise that existing loan (US-2.4).
typedef LoanFormTarget = ({int borrowerId, LoanSummary? existing});

/// State of the loan form (ECR-04). Errors are derived from the fields, never
/// stored.
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

    /// Amount already repaid of the edited loan, zero for a new one (RG-13).
    @Default(Money.zero) Money repaid,

    /// First repayment of the edited loan, null if none (RG-11, RG-17).
    LocalDay? firstRepaymentDate,

    /// The form edits an existing loan.
    @Default(false) bool isEditing,

    /// The amount was edited: its error can be shown.
    @Default(false) bool isAmountDirty,
    @Default(false) bool isSaving,

    /// The last save failed for an unexpected reason.
    @Default(false) bool hasSaveFailed,
  }) = _LoanFormState;

  const LoanFormState._();

  LoanAmountError? get amountError =>
      LoanValidator.validateAmountInput(amountInput, currency, repaid: repaid);

  LoanDateError? get loanDateError => LoanValidator.validateLoanDate(
    loanDate,
    today,
    firstRepaymentDate: firstRepaymentDate,
  );

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

final loanFormControllerProvider = NotifierProvider.autoDispose
    .family<LoanFormController, LoanFormState, LoanFormTarget>(
      LoanFormController.new,
    );

/// Edits and saves a new loan (US-2.1) or an existing one (US-2.4).
class LoanFormController extends Notifier<LoanFormState> {
  LoanFormController(this._target);

  final LoanFormTarget _target;

  @override
  LoanFormState build() {
    final today = LocalDay.today();
    final currency = ref.watch(currencyProvider);
    final existing = _target.existing;
    if (existing == null) {
      return LoanFormState(currency: currency, today: today, loanDate: today);
    }
    final loan = existing.loan;
    return LoanFormState(
      currency: currency,
      today: today,
      loanDate: loan.loanDate,
      promisedReturnDate: loan.promisedReturnDate,
      amountInput: MoneyFormatter.formatAmount(loan.amount, currency),
      note: loan.note ?? '',
      repaid: existing.repaid,
      firstRepaymentDate: existing.firstRepaymentDate,
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

  void loanDateChanged(LocalDay date) =>
      state = state.copyWith(loanDate: date, hasSaveFailed: false);

  void promisedReturnDateChanged(LocalDay? date) =>
      state = state.copyWith(promisedReturnDate: date, hasSaveFailed: false);

  void noteChanged(String note) =>
      state = state.copyWith(note: note, hasSaveFailed: false);

  /// Returns true if the loan was saved.
  Future<bool> save() async {
    if (!state.canSave) {
      state = state.copyWith(isAmountDirty: true);
      return false;
    }
    final amount = MoneyParser.tryParse(state.amountInput, state.currency)!;
    final trimmedNote = state.note.trim();
    final note = trimmedNote.isEmpty ? null : trimmedNote;
    state = state.copyWith(isSaving: true, hasSaveFailed: false);
    final repository = ref.read(loanRepositoryProvider);
    try {
      final existing = _target.existing;
      if (existing == null) {
        await repository.add(
          borrowerId: _target.borrowerId,
          amount: amount,
          loanDate: state.loanDate,
          promisedReturnDate: state.promisedReturnDate,
          note: note,
        );
      } else {
        await repository.update(
          existing.loan.copyWith(
            amount: amount,
            loanDate: state.loanDate,
            promisedReturnDate: state.promisedReturnDate,
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
