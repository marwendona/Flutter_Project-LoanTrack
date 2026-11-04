import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Saves a backup file where the user chooses.
abstract interface class BackupFileSaver {
  /// Returns false if the user cancelled.
  Future<bool> save({required String fileName, required Uint8List bytes});
}

/// [BackupFileSaver] using the Android system file picker (SAF): no storage
/// permission needed.
class FilePickerBackupFileSaver implements BackupFileSaver {
  const FilePickerBackupFileSaver();

  @override
  Future<bool> save({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final uri = await FilePicker.saveFile(
      fileName: fileName,
      bytes: bytes,
      mimeType: 'application/json',
    );
    return uri != null;
  }
}
