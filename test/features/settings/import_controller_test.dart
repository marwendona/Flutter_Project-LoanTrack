import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/data/backup/backup_file_picker.dart';
import 'package:loantrack/data/backup/backup_validator.dart';
import 'package:loantrack/data/database/app_database.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/features/settings/import_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockBackupFilePicker extends Mock implements BackupFilePicker {}

void main() {
  late _MockBackupFilePicker picker;
  late ProviderContainer container;

  final backupFile = Uint8List.fromList(
    utf8.encode(
      jsonEncode({
        'formatVersion': 1,
        'exportedAt': '2026-11-04T09:30:00.000Z',
        'currency': 'EUR',
        'borrowers': [
          {
            'id': 7,
            'name': 'Ali',
            'phone': null,
            'note': null,
            'createdAt': '2026-10-01',
          },
        ],
        'loans': [
          {
            'id': 3,
            'borrowerId': 7,
            'amountMinor': 10000,
            'loanDate': '2026-10-01',
            'promisedReturnDate': null,
            'note': null,
          },
        ],
        'repayments': <Object>[],
      }),
    ),
  );

  setUp(() {
    picker = _MockBackupFilePicker();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final db = AppDatabase(NativeDatabase.memory());
          ref.onDispose(db.close);
          return db;
        }),
        settingsStoreProvider.overrideWithValue(InMemorySettingsStore()),
        backupFilePickerProvider.overrideWithValue(picker),
      ],
    );
  });
  tearDown(() => container.dispose());

  ImportController controller() =>
      container.read(importControllerProvider.notifier);

  test('returns null when the file picker is cancelled', () async {
    when(() => picker.pick()).thenAnswer((_) async => null);

    expect(await controller().pick(), isNull);
    expect(container.read(importControllerProvider), isFalse);
  });

  test('decodes the chosen file without writing anything', () async {
    when(() => picker.pick()).thenAnswer((_) async => backupFile);
    await container.read(borrowerRepositoryProvider).add(name: 'Sana');

    final backup = await controller().pick();

    expect(backup!.borrowers.single.name, 'Ali');
    expect(backup.loans, hasLength(1));
    final names = await container
        .read(borrowerRepositoryProvider)
        .watchAll()
        .first;
    expect(names.map((b) => b.name), ['Sana']);
    expect(container.read(importControllerProvider), isFalse);
  });

  test('refuses an invalid file', () async {
    when(() => picker.pick())
        .thenAnswer((_) async => Uint8List.fromList(utf8.encode('[]')));

    await expectLater(
      controller().pick(),
      throwsA(isA<InvalidBackupException>()),
    );
    expect(container.read(importControllerProvider), isFalse);
  });

  test('replaces the data and applies the backup currency', () async {
    when(() => picker.pick()).thenAnswer((_) async => backupFile);
    await container.read(borrowerRepositoryProvider).add(name: 'Sana');
    expect(container.read(currencyProvider), Currency.tnd);

    await controller().restore((await controller().pick())!);

    final borrowers = await container
        .read(borrowerRepositoryProvider)
        .watchAll()
        .first;
    expect(borrowers.map((b) => (b.id, b.name)), [(7, 'Ali')]);
    expect(container.read(currencyProvider).code, 'EUR');
    expect(container.read(importControllerProvider), isFalse);
  });
}
