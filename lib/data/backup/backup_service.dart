import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart';

import '../../core/date/local_day.dart';
import '../database/app_database.dart';
import '../settings/settings_store.dart';
import 'backup_dto.dart';

/// Builds the backup file of all the data (RG-50).
class BackupService {
  BackupService(this._database, this._settings);

  final AppDatabase _database;
  final SettingsStore _settings;

  /// Proposed file name: `loantrack-sauvegarde-AAAA-MM-JJ.json` (US-5.2).
  static String fileName(LocalDay day) => 'loantrack-sauvegarde-$day.json';

  /// A snapshot of all the data, read in one transaction so that it is
  /// consistent.
  Future<BackupDto> createBackup() => _database.transaction(() async {
    final borrowers = await (_database.select(
      _database.borrowers,
    )..orderBy([(b) => OrderingTerm.asc(b.id)])).get();
    final loans = await (_database.select(
      _database.loans,
    )..orderBy([(l) => OrderingTerm.asc(l.id)])).get();
    final repayments = await (_database.select(
      _database.repayments,
    )..orderBy([(r) => OrderingTerm.asc(r.id)])).get();

    return BackupDto(
      formatVersion: BackupDto.currentFormatVersion,
      exportedAt: clock.now().toUtc(),
      currency: _settings.currency.code,
      borrowers: [
        for (final row in borrowers)
          BorrowerDto(
            id: row.id,
            name: row.name,
            phone: row.phone,
            note: row.note,
            createdAt: row.createdAt,
          ),
      ],
      loans: [
        for (final row in loans)
          LoanDto(
            id: row.id,
            borrowerId: row.borrowerId,
            amountMinor: row.amountMinor,
            loanDate: row.loanDate,
            promisedReturnDate: row.promisedReturnDate,
            note: row.note,
          ),
      ],
      repayments: [
        for (final row in repayments)
          RepaymentDto(
            id: row.id,
            loanId: row.loanId,
            amountMinor: row.amountMinor,
            repaymentDate: row.repaymentDate,
            note: row.note,
          ),
      ],
    );
  });

  /// The backup as indented UTF-8 JSON.
  static Uint8List encode(BackupDto backup) => Uint8List.fromList(
    utf8.encode(const JsonEncoder.withIndent('  ').convert(backup.toJson())),
  );
}
