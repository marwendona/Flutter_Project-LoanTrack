import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/date/date_formatter.dart';
import '../../core/date/local_day.dart';
import '../../core/money/currency.dart';
import '../../core/theme/app_theme_mode.dart';
import '../../data/backup/backup_dto.dart';
import '../../data/backup/backup_validator.dart';
import '../../l10n/generated/app_localizations.dart';
import 'app_version_provider.dart';
import 'currency_controller.dart';
import 'export_controller.dart';
import 'import_controller.dart';
import 'theme_controller.dart';

/// ECR-06 — Settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).navSettings)),
      body: ListView(
        children: const [
          _CurrencyTile(),
          _ExportTile(),
          _ImportTile(),
          _ThemeTile(),
          _VersionTile(),
        ],
      ),
    );
  }
}

/// Theme setting: system, light or dark, applied immediately (CR-030).
class _ThemeTile extends ConsumerWidget {
  const _ThemeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeControllerProvider);

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(l10n.settingsTheme),
      subtitle: Text(l10n.settingsThemeValue(mode.name)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _chooseTheme(context, ref, mode),
    );
  }

  Future<void> _chooseTheme(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode current,
  ) async {
    final chosen = await showDialog<AppThemeMode>(
      context: context,
      builder: (_) => _ThemeDialog(current: current),
    );
    if (chosen == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(themeControllerProvider.notifier).change(chosen);
    } catch (_) {
      // The store throws a StateError when shared_preferences fails.
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsThemeChangeError)),
      );
    }
  }
}

class _ThemeDialog extends StatelessWidget {
  const _ThemeDialog({required this.current});

  final AppThemeMode current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleDialog(
      title: Text(l10n.settingsThemeDialogTitle),
      children: [
        for (final mode in AppThemeMode.values)
          ListTile(
            title: Text(l10n.settingsThemeValue(mode.name)),
            selected: mode == current,
            trailing: mode == current ? const Icon(Icons.check) : null,
            onTap: () => Navigator.of(context).pop(mode),
          ),
      ],
    );
  }
}

/// Installed app version, read only (CR-030).
class _VersionTile extends ConsumerWidget {
  const _VersionTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final version = ref.watch(appVersionProvider);

    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(l10n.settingsVersion),
      subtitle: Text(switch (version) {
        AsyncData(:final value) => l10n.settingsVersionValue(
          value.name,
          value.code,
        ),
        AsyncError() => l10n.settingsVersionUnavailable,
        _ => '',
      }),
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

/// Data export to a JSON file chosen with the system file picker (RG-50).
class _ExportTile extends ConsumerWidget {
  const _ExportTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final exporting = ref.watch(exportControllerProvider);

    return ListTile(
      leading: const Icon(Icons.upload_file_outlined),
      title: Text(l10n.settingsExport),
      subtitle: Text(l10n.settingsExportSubtitle),
      trailing: exporting
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: exporting ? null : () => _export(context, ref),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    String? message;
    try {
      final result = await ref.read(exportControllerProvider.notifier).export();
      if (result == ExportResult.saved) message = l10n.settingsExportSuccess;
    } catch (_) {
      // Any failure (database, file picker, write) is reported, never fatal.
      message = l10n.settingsExportError;
    }
    if (message != null) {
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

/// Data import from a JSON backup chosen with the system file picker, after
/// confirmation (RG-51).
class _ImportTile extends ConsumerWidget {
  const _ImportTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final importing = ref.watch(importControllerProvider);

    return ListTile(
      leading: const Icon(Icons.download_outlined),
      title: Text(l10n.settingsImport),
      subtitle: Text(l10n.settingsImportSubtitle),
      trailing: importing
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: importing ? null : () => _import(context, ref),
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(importControllerProvider.notifier);
    void show(String message) =>
        messenger.showSnackBar(SnackBar(content: Text(message)));

    final BackupDto? backup;
    try {
      backup = await controller.pick();
    } on InvalidBackupException catch (e) {
      show(switch (e.reason) {
        InvalidBackupReason.invalid => l10n.settingsImportInvalid,
        InvalidBackupReason.unsupportedVersion =>
          l10n.settingsImportUnsupportedVersion,
      });
      return;
    } catch (_) {
      // Any other failure (file picker, read) is reported, never fatal.
      show(l10n.settingsImportError);
      return;
    }
    if (backup == null || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _ImportConfirmDialog(backup: backup!),
    );
    if (confirmed != true) return;

    try {
      await controller.restore(backup);
      show(l10n.settingsImportSuccess);
    } catch (_) {
      show(l10n.settingsImportError);
    }
  }
}

/// Preview of the backup and confirmation of the replacement (US-5.3).
class _ImportConfirmDialog extends StatelessWidget {
  const _ImportConfirmDialog({required this.backup});

  final BackupDto backup;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final exportDay = LocalDay.fromDateTime(backup.exportedAt.toLocal());
    return AlertDialog(
      title: Text(l10n.settingsImportConfirmTitle),
      content: Text(
        l10n.settingsImportConfirmMessage(
          DateFormatter.format(exportDay),
          backup.borrowers.length,
          backup.loans.length,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.settingsImportCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.settingsImportConfirm),
        ),
      ],
    );
  }
}

String _currencyLabel(AppLocalizations l10n, Currency currency) =>
    l10n.settingsCurrencyValue(currency.code, l10n.currencyName(currency.code));
