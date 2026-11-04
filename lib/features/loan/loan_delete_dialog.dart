import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/date/date_formatter.dart';
import '../../core/money/money_formatter.dart';
import '../../data/providers.dart';
import '../../domain/models/loan.dart';
import '../../l10n/generated/app_localizations.dart';

/// Asks to confirm the deletion of [loan], then deletes it with its
/// repayments (RG-14).
///
/// Returns true if the loan was deleted.
Future<bool> showLoanDeleteDialog(
  BuildContext context,
  WidgetRef ref,
  Loan loan,
) async {
  final l10n = AppLocalizations.of(context);
  final currency = ref.read(currencyProvider);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.loanDeleteTitle),
      content: Text(
        l10n.loanDeleteMessage(
          MoneyFormatter.format(loan.amount, currency),
          DateFormatter.format(loan.loanDate),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.loanDeleteConfirm),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;
  try {
    await ref.read(loanRepositoryProvider).delete(loan.id);
    return true;
  } on Exception {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.saveError)));
    }
    return false;
  }
}
