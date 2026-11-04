import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money/money_formatter.dart';
import '../../data/providers.dart';
import '../../domain/models/borrower_summary.dart';
import '../../l10n/generated/app_localizations.dart';

/// Asks to confirm the deletion of a borrower, showing the number of loans and
/// the remaining due that will be deleted (RG-03), then deletes it with its
/// loans and repayments.
///
/// Returns true if the borrower was deleted (ECR-02, ECR-03).
Future<bool> showBorrowerDeleteDialog(
  BuildContext context,
  WidgetRef ref,
  BorrowerSummary summary,
) async {
  final l10n = AppLocalizations.of(context);
  final currency = ref.read(currencyProvider);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.borrowerDeleteTitle),
      content: Text(
        l10n.borrowerDeleteMessage(
          summary.loanCount,
          MoneyFormatter.format(summary.remaining, currency),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.borrowerDeleteConfirm),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;
  try {
    await ref.read(borrowerRepositoryProvider).delete(summary.borrower.id);
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.saveError)));
    }
    return false;
  }
}
