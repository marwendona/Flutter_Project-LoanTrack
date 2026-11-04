import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/backup/backup_dto.dart';
import 'package:loantrack/data/backup/backup_service.dart';
import 'package:loantrack/data/backup/backup_validator.dart';
import 'package:loantrack/data/database/app_database.dart';
import 'package:loantrack/data/repositories/borrower_repository_impl.dart';
import 'package:loantrack/data/repositories/loan_repository_impl.dart';
import 'package:loantrack/data/repositories/repayment_repository_impl.dart';
import 'package:loantrack/data/settings/settings_store.dart';

void main() {
  final now = DateTime.utc(2026, 11, 4, 9, 30);

  late AppDatabase database;
  late InMemorySettingsStore settings;
  late BackupService service;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    settings = InMemorySettingsStore();
    service = BackupService(database, settings);
  });
  tearDown(() => database.close());

  Future<void> seed() => withClock(Clock.fixed(now), () async {
    final borrowers = BorrowerRepositoryImpl(database.borrowersDao);
    final loans = LoanRepositoryImpl(database.loansDao);
    final repayments = RepaymentRepositoryImpl(database.repaymentsDao);

    final ali = await borrowers.add(name: 'Ali', phone: '+216 20 000 000');
    final sana = await borrowers.add(name: 'Sana', note: 'Collègue');
    final loan1 = await loans.add(
      borrowerId: ali,
      amount: const Money(1250500),
      loanDate: LocalDay(2026, 10, 1),
      promisedReturnDate: LocalDay(2026, 12, 31),
      note: 'Voiture',
    );
    await loans.add(
      borrowerId: sana,
      amount: const Money(300000),
      loanDate: LocalDay(2026, 9, 15),
    );
    await repayments.add(
      loanId: loan1,
      amount: const Money(250500),
      repaymentDate: LocalDay(2026, 10, 20),
      note: 'Espèces',
    );
  });

  test('proposes loantrack-sauvegarde-AAAA-MM-JJ.json (US-5.2)', () {
    expect(
      BackupService.fileName(LocalDay(2026, 3, 7)),
      'loantrack-sauvegarde-2026-03-07.json',
    );
  });

  test('exports an empty database', () async {
    final backup = await withClock(Clock.fixed(now), service.createBackup);

    expect(backup.formatVersion, 1);
    expect(backup.exportedAt, now);
    expect(backup.currency, 'TND');
    expect(backup.borrowers, isEmpty);
    expect(backup.loans, isEmpty);
    expect(backup.repayments, isEmpty);
  });

  test('exports all the data with format version, date and currency '
      '(RG-50)', () async {
    await seed();
    await settings.setCurrency(const Currency(code: 'EUR', decimals: 2));

    final backup = await withClock(Clock.fixed(now), service.createBackup);
    final json = jsonDecode(
      utf8.decode(BackupService.encode(backup)),
    ) as Map<String, dynamic>;

    expect(json, {
      'formatVersion': 1,
      'exportedAt': '2026-11-04T09:30:00.000Z',
      'currency': 'EUR',
      'borrowers': [
        {
          'id': 1,
          'name': 'Ali',
          'phone': '+216 20 000 000',
          'note': null,
          'createdAt': '2026-11-04',
        },
        {
          'id': 2,
          'name': 'Sana',
          'phone': null,
          'note': 'Collègue',
          'createdAt': '2026-11-04',
        },
      ],
      'loans': [
        {
          'id': 1,
          'borrowerId': 1,
          'amountMinor': 1250500,
          'loanDate': '2026-10-01',
          'promisedReturnDate': '2026-12-31',
          'note': 'Voiture',
        },
        {
          'id': 2,
          'borrowerId': 2,
          'amountMinor': 300000,
          'loanDate': '2026-09-15',
          'promisedReturnDate': null,
          'note': null,
        },
      ],
      'repayments': [
        {
          'id': 1,
          'loanId': 1,
          'amountMinor': 250500,
          'repaymentDate': '2026-10-20',
          'note': 'Espèces',
        },
      ],
    });
  });

  test('the encoded backup decodes back to the same content', () async {
    await seed();
    final backup = await service.createBackup();

    final decoded = BackupDto.fromJson(
      jsonDecode(utf8.decode(BackupService.encode(backup)))
          as Map<String, dynamic>,
    );

    expect(decoded, backup);
  });

  group('import (US-5.3)', () {
    Uint8List bytesOf(Object? json) =>
        Uint8List.fromList(utf8.encode(jsonEncode(json)));

    Future<Map<String, dynamic>> exportedJson() async => jsonDecode(
      utf8.decode(BackupService.encode(await service.createBackup())),
    ) as Map<String, dynamic>;

    Matcher refused([
      InvalidBackupReason reason = InvalidBackupReason.invalid,
    ]) => throwsA(
      isA<InvalidBackupException>().having((e) => e.reason, 'reason', reason),
    );

    test('export → import gives back identical data and currency', () async {
      await seed();
      await settings.setCurrency(const Currency(code: 'EUR', decimals: 2));
      final exported = await withClock(Clock.fixed(now), service.createBackup);
      final bytes = BackupService.encode(exported);

      // Restored on another (new) device.
      final otherDatabase = AppDatabase(NativeDatabase.memory());
      addTearDown(otherDatabase.close);
      final otherSettings = InMemorySettingsStore();
      final otherService = BackupService(otherDatabase, otherSettings);
      await BorrowerRepositoryImpl(otherDatabase.borrowersDao)
          .add(name: 'Ancien');

      await otherService.restore(BackupService.decode(bytes));

      expect(otherSettings.currency, const Currency(code: 'EUR', decimals: 2));
      expect(
        await withClock(Clock.fixed(now), otherService.createBackup),
        exported,
      );
      expect(
        (await otherDatabase.select(otherDatabase.borrowers).get()).map(
          (b) => b.nameKey,
        ),
        ['ali', 'sana'],
      );
    });

    test('new data gets fresh ids after an import', () async {
      await seed();
      final bytes = BackupService.encode(await service.createBackup());
      await database.delete(database.borrowers).go();

      await service.restore(BackupService.decode(bytes));
      final id = await BorrowerRepositoryImpl(database.borrowersDao)
          .add(name: 'Nouveau');

      expect(id, greaterThan(2));
    });

    test('rolls everything back if the import fails (ENF-06)', () async {
      await seed();
      Future<BackupDto> snapshot() =>
          withClock(Clock.fixed(now), service.createBackup);
      final before = await snapshot();
      final failing = BackupService(database, _FailingSettingsStore());

      await expectLater(
        failing.restore(
          before.copyWith(borrowers: [], loans: [], repayments: []),
        ),
        throwsStateError,
      );

      expect(await snapshot(), before);
    });

    test('refuses a file that is not JSON', () {
      expect(
        () => BackupService.decode(Uint8List.fromList([0xff, 0xfe, 0x00])),
        refused(),
      );
      expect(
        () => BackupService.decode(Uint8List.fromList(utf8.encode('{oops'))),
        refused(),
      );
    });

    test('refuses JSON that is not a backup object', () {
      expect(() => BackupService.decode(bytesOf([1, 2])), refused());
      expect(
        () => BackupService.decode(bytesOf({'currency': 'TND'})),
        refused(),
      );
    });

    test('refuses an unknown format version (RG-51)', () async {
      final json = await exportedJson()
        ..['formatVersion'] = 2;

      expect(
        () => BackupService.decode(bytesOf(json)),
        refused(InvalidBackupReason.unsupportedVersion),
      );
    });

    test('refuses a missing field, a wrong type or a bad date', () async {
      await seed();
      final json = await exportedJson();
      expect(() => BackupService.decode(bytesOf(json)), returnsNormally);

      Map<String, dynamic> first(Map<String, dynamic> j, String list) =>
          (j[list] as List<dynamic>).first as Map<String, dynamic>;
      final cases = <String, void Function(Map<String, dynamic>)>{
        'missing loans': (j) => j.remove('loans'),
        'missing name': (j) => first(j, 'borrowers').remove('name'),
        'amount as string': (j) => first(j, 'loans')['amountMinor'] = '1000',
        'decimal amount': (j) => first(j, 'loans')['amountMinor'] = 12.5,
        'bad date': (j) => first(j, 'loans')['loanDate'] = '01/10/2026',
        'impossible date': (j) => first(j, 'loans')['loanDate'] = '2026-02-30',
        'bad export date': (j) => j['exportedAt'] = 'hier',
      };
      for (final entry in cases.entries) {
        final copy = jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
        entry.value(copy);
        expect(
          () => BackupService.decode(bytesOf(copy)),
          refused(),
          reason: entry.key,
        );
      }
    });

    test('refuses data breaking a business rule (RG-51)', () async {
      await seed();
      final json = await exportedJson();
      ((json['repayments'] as List<dynamic>).first
              as Map<String, dynamic>)['amountMinor'] =
          2000000;

      expect(() => BackupService.decode(bytesOf(json)), refused());
    });
  });

  group('LocalDayJsonConverter', () {
    const converter = LocalDayJsonConverter();

    test('writes and reads ISO 8601 dates', () {
      expect(converter.toJson(LocalDay(2026, 1, 5)), '2026-01-05');
      expect(converter.fromJson('2026-01-05'), LocalDay(2026, 1, 5));
    });

    test('rejects malformed or impossible dates', () {
      expect(() => converter.fromJson('05/01/2026'), throwsFormatException);
      expect(() => converter.fromJson('2026-02-30'), throwsArgumentError);
    });
  });
}

/// Fails when saving the currency, the last step of an import.
class _FailingSettingsStore implements SettingsStore {
  @override
  Currency get currency => Currency.tnd;

  @override
  Future<void> setCurrency(Currency currency) async =>
      throw StateError('not saved');
}
