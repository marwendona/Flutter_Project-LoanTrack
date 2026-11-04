import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money/currency.dart';
import '../../l10n/generated/app_localizations.dart';
import 'currency_controller.dart';

/// ECR-06 — Settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).navSettings)),
      body: ListView(children: const [_CurrencyTile()]),
    );
  }
}

/// Currency setting (RG-40), read-only once a loan exists (RG-41).
class _CurrencyTile extends ConsumerWidget {
  const _CurrencyTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyControllerProvider);
    // Locked while unknown: never allow a change before knowing there is no
    // loan.
    final locked = ref.watch(currencyLockedProvider).value ?? true;
    final value = _currencyLabel(l10n, currency);

    return ListTile(
      leading: const Icon(Icons.payments_outlined),
      title: Text(l10n.settingsCurrency),
      subtitle: Text(locked ? '$value\n${l10n.settingsCurrencyLocked}' : value),
      isThreeLine: locked,
      trailing: locked
          ? Icon(Icons.lock_outline, semanticLabel: l10n.settingsCurrencyLocked)
          : const Icon(Icons.chevron_right),
      onTap: locked ? null : () => _chooseCurrency(context, ref, currency),
    );
  }

  Future<void> _chooseCurrency(
    BuildContext context,
    WidgetRef ref,
    Currency current,
  ) async {
    final chosen = await showDialog<Currency>(
      context: context,
      builder: (_) => _CurrencyDialog(current: current),
    );
    if (chosen == null || !context.mounted) return;
    try {
      await ref.read(currencyControllerProvider.notifier).change(chosen);
    } on Exception {
      if (!context.mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsCurrencyChangeError)));
    }
  }
}

class _CurrencyDialog extends StatelessWidget {
  const _CurrencyDialog({required this.current});

  final Currency current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleDialog(
      title: Text(l10n.settingsCurrencyDialogTitle),
      children: [
        for (final currency in Currency.supported)
          ListTile(
            title: Text(_currencyLabel(l10n, currency)),
            selected: currency == current,
            trailing: currency == current ? const Icon(Icons.check) : null,
            onTap: () => Navigator.of(context).pop(currency),
          ),
      ],
    );
  }
}

String _currencyLabel(AppLocalizations l10n, Currency currency) =>
    l10n.settingsCurrencyValue(currency.code, l10n.currencyName(currency.code));
