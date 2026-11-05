import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/widgets/form_actions.dart';
import '../../domain/models/borrower.dart';
import '../../domain/services/borrower_validator.dart';
import '../../l10n/generated/app_localizations.dart';
import 'borrower_form_controller.dart';

/// Opens the "Nouvel emprunteur" bottom sheet (ECR-02, US-1.2).
Future<void> showBorrowerFormSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => const BorrowerFormSheet(),
  );
}

/// Opens the "Modifier l'emprunteur" bottom sheet (US-1.4).
Future<void> showBorrowerEditSheet(BuildContext context, Borrower borrower) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => BorrowerFormSheet(borrower: borrower),
  );
}

class BorrowerFormSheet extends ConsumerStatefulWidget {
  const BorrowerFormSheet({super.key, this.borrower});

  final Borrower? borrower;

  @override
  ConsumerState<BorrowerFormSheet> createState() => _BorrowerFormSheetState();
}

class _BorrowerFormSheetState extends ConsumerState<BorrowerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.borrower != null) {
      _name.text = widget.borrower!.name;
      _phone.text = widget.borrower!.phone ?? '';
      _note.text = widget.borrower!.note ?? '';
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final saved = await ref
        .read(borrowerFormControllerProvider.notifier)
        .save(
          name: _name.text,
          phone: _phone.text,
          note: _note.text,
          borrowerId: widget.borrower?.id,
        );
    if (saved && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(borrowerFormControllerProvider);
    final controller = ref.read(borrowerFormControllerProvider.notifier);

    return Padding(
      // Keeps the fields above the keyboard.
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.borrower != null
                    ? l10n.borrowerFormEditTitle
                    : l10n.borrowerFormNewTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                maxLength: BorrowerValidator.nameMaxLength,
                decoration: InputDecoration(labelText: l10n.borrowerFormName),
                forceErrorText: state.isDuplicateName
                    ? l10n.borrowerNameDuplicate
                    : null,
                onChanged: (_) => controller.nameChanged(),
                validator: (value) =>
                    switch (BorrowerValidator.validateName(value ?? '')) {
                      BorrowerNameError.required => l10n.borrowerNameRequired,
                      BorrowerNameError.tooLong => l10n.borrowerNameTooLong(
                        BorrowerValidator.nameMaxLength,
                      ),
                      null => null,
                    },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: l10n.borrowerFormPhone),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _note,
                minLines: 1,
                maxLines: 4,
                maxLength: BorrowerValidator.noteMaxLength,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.borrowerFormNote),
                validator: (value) => BorrowerValidator.isNoteValid(value ?? '')
                    ? null
                    : l10n.noteTooLong(BorrowerValidator.noteMaxLength),
              ),
              if (state.hasSaveFailed) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.saveError,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              FormActions(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.actionCancel),
                  ),
                  FilledButton(
                    onPressed: state.isSaving ? null : _save,
                    child: Text(l10n.actionSave),
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
