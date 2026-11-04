import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/backup/backup_dto.dart';
import 'package:loantrack/data/backup/backup_service.dart';
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
