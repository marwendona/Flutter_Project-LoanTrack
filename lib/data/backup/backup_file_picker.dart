import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Lets the user choose a backup file to import.
abstract interface class BackupFilePicker {
  /// The content of the chosen file, null if the user cancelled.
  Future<Uint8List?> pick();
}

/// [BackupFilePicker] using the Android system file picker (SAF): no storage
/// permission needed.
class FilePickerBackupFilePicker implements BackupFilePicker {
  const FilePickerBackupFilePicker();

  @override
  Future<Uint8List?> pick() async {
    // Any type: file managers often report JSON as application/octet-stream,
    // the content is validated anyway (RG-51).
    final file = await FilePicker.pickFile();
    return file?.readAsBytes();
  }
}
