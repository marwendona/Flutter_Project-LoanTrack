import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/date/date_formatter.dart';
import '../../core/money/money_formatter.dart';
import '../../data/providers.dart';
import '../../domain/models/repayment.dart';
import '../../l10n/generated/app_localizations.dart';

/// Asks to confirm the deletion of [repayment], then deletes it (RG-19).
///
/// Returns true if the repayment was deleted.
Future<bool> showRepaymentDeleteDialog(
  BuildContext context,
  WidgetRef ref,
  Repayment repayment,
) async {
  final l10n = AppLocalizations.of(context);
  final currency = ref.read(currencyProvider);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.repaymentDeleteTitle),
      content: Text(
        l10n.repaymentDeleteMessage(
          MoneyFormatter.format(repayment.amount, currency),
          DateFormatter.format(repayment.repaymentDate),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.repaymentDeleteConfirm),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;
  try {
    await ref.read(repaymentRepositoryProvider).delete(repayment.id);
    return true;
  } on Exception {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.saveError)));
    }
    return false;
  }
}
