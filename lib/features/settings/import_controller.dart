import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/backup/backup_dto.dart';
import '../../data/backup/backup_service.dart';
import '../../data/providers.dart';

/// The data import of ECR-06 (RG-51). The state is true while importing.
final importControllerProvider = NotifierProvider<ImportController, bool>(
  ImportController.new,
);

class ImportController extends Notifier<bool> {
  @override
  bool build() => false;

  /// Lets the user choose a backup file and validates it without writing
  /// anything: null if the user cancelled, throws an `InvalidBackupException`
  /// if the file is refused, rethrows any other failure.
  Future<BackupDto?> pick() async {
    state = true;
    try {
      final bytes = await ref.read(backupFilePickerProvider).pick();
      return bytes == null ? null : BackupService.decode(bytes);
    } finally {
      state = false;
    }
  }

  /// Replaces all the data and the currency with [backup], once confirmed by
  /// the user; rethrows any failure (nothing is then modified).
  Future<void> restore(BackupDto backup) async {
    state = true;
    try {
      await ref.read(backupServiceProvider).restore(backup);
      ref.invalidate(currencyProvider);
    } finally {
      state = false;
    }
  }
}
