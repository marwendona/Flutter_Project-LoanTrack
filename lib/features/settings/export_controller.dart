import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date/local_day.dart';
import '../../data/backup/backup_service.dart';
import '../../data/providers.dart';

/// Outcome of an export (US-5.2).
enum ExportResult { saved, cancelled }

/// The data export of ECR-06 (RG-50). The state is true while exporting.
final exportControllerProvider = NotifierProvider<ExportController, bool>(
  ExportController.new,
);

class ExportController extends Notifier<bool> {
  @override
  bool build() => false;

  /// Builds the backup and lets the user choose where to save it; rethrows
  /// any failure.
  Future<ExportResult> export() async {
    state = true;
    try {
      final backup = await ref.read(backupServiceProvider).createBackup();
      final saved = await ref
          .read(backupFileSaverProvider)
          .save(
            fileName: BackupService.fileName(LocalDay.today()),
            bytes: BackupService.encode(backup),
          );
      return saved ? ExportResult.saved : ExportResult.cancelled;
    } finally {
      state = false;
    }
  }
}
