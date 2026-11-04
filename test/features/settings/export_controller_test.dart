import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/data/backup/backup_file_saver.dart';
import 'package:loantrack/data/database/app_database.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/features/settings/export_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockBackupFileSaver extends Mock implements BackupFileSaver {}

void main() {
  late _MockBackupFileSaver saver;
  late ProviderContainer container;

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    saver = _MockBackupFileSaver();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final db = AppDatabase(NativeDatabase.memory());
          ref.onDispose(db.close);
          return db;
        }),
        settingsStoreProvider.overrideWithValue(InMemorySettingsStore()),
        backupFileSaverProvider.overrideWithValue(saver),
      ],
    );
  });
  tearDown(() => container.dispose());

  Future<ExportResult> export() => withClock(
    Clock.fixed(DateTime(2026, 11, 4, 23, 59)),
    () => container.read(exportControllerProvider.notifier).export(),
  );

  test('saves the JSON backup under the dated file name', () async {
    when(
      () => saver.save(
        fileName: any(named: 'fileName'),
        bytes: any(named: 'bytes'),
      ),
    ).thenAnswer((_) async => true);
    await container.read(borrowerRepositoryProvider).add(name: 'Ali');

    expect(await export(), ExportResult.saved);

    final captured = verify(
      () => saver.save(
        fileName: 'loantrack-sauvegarde-2026-11-04.json',
        bytes: captureAny(named: 'bytes'),
      ),
    ).captured;
    final json = jsonDecode(
      utf8.decode(captured.single as Uint8List),
    ) as Map<String, dynamic>;
    expect(json['formatVersion'], 1);
    expect(json['currency'], 'TND');
    expect(json['borrowers'], hasLength(1));
    expect(container.read(exportControllerProvider), isFalse);
  });

  test('reports a cancelled file picker', () async {
    when(
      () => saver.save(
        fileName: any(named: 'fileName'),
        bytes: any(named: 'bytes'),
      ),
    ).thenAnswer((_) async => false);

    expect(await export(), ExportResult.cancelled);
    expect(container.read(exportControllerProvider), isFalse);
  });

  test('rethrows a failure and stops exporting', () async {
    when(
      () => saver.save(
        fileName: any(named: 'fileName'),
        bytes: any(named: 'bytes'),
      ),
    ).thenThrow(Exception('write failed'));

    await expectLater(export(), throwsException);
    expect(container.read(exportControllerProvider), isFalse);
  });
}
