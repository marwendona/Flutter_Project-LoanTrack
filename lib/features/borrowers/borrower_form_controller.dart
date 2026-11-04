import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/services/borrower_validator.dart';

/// State of the "Nouvel emprunteur" form.
final class BorrowerFormState {
  const BorrowerFormState({
    this.isSaving = false,
    this.isDuplicateName = false,
    this.hasSaveFailed = false,
  });

  final bool isSaving;

  /// The last save was refused: the name is already used (RG-02).
  final bool isDuplicateName;

  /// The last save failed for an unexpected reason.
  final bool hasSaveFailed;
}

final borrowerFormControllerProvider =
    NotifierProvider.autoDispose<BorrowerFormController, BorrowerFormState>(
      BorrowerFormController.new,
    );

/// Saves a new borrower (US-1.2). Field validation happens in the form with
/// [BorrowerValidator]; this controller handles the save and its errors.
class BorrowerFormController extends Notifier<BorrowerFormState> {
  @override
  BorrowerFormState build() => const BorrowerFormState();

  /// The name was edited: the duplicate error no longer applies.
  void nameChanged() {
    if (state.isDuplicateName) state = const BorrowerFormState();
  }

  /// Returns true if the borrower was saved.
  Future<bool> save({
    required String name,
    String? phone,
    String? note,
    int? borrowerId,
  }) async {
    if (state.isSaving ||
        BorrowerValidator.validateName(name) != null ||
        (note != null && !BorrowerValidator.isNoteValid(note))) {
      return false;
    }
    state = const BorrowerFormState(isSaving: true);
    try {
      if (borrowerId == null) {
        await ref
            .read(borrowerRepositoryProvider)
            .add(name: name, phone: phone, note: note);
      } else {
        await ref
            .read(borrowerRepositoryProvider)
            .update(id: borrowerId, name: name, phone: phone, note: note);
      }
      if (ref.mounted) state = const BorrowerFormState();
      return true;
    } on DuplicateBorrowerNameException {
      if (ref.mounted) {
        state = const BorrowerFormState(isDuplicateName: true);
      }
      return false;
    } on Exception {
      if (ref.mounted) state = const BorrowerFormState(hasSaveFailed: true);
      return false;
    }
  }
}
