import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart';

import '../../core/date/local_day.dart';
import '../../core/money/currency.dart';
import '../../domain/services/borrower_name_key.dart';
import '../database/app_database.dart';
import '../settings/settings_store.dart';
import 'backup_dto.dart';
import 'backup_validator.dart';

/// Builds the backup file of all the data (RG-50) and restores it (RG-51).
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

  /// Reads and fully validates a backup file (RG-51); throws an
  /// [InvalidBackupException] if it cannot be imported.
  static BackupDto decode(Uint8List bytes) {
    final Object? json;
    try {
      json = jsonDecode(utf8.decode(bytes));
    } on FormatException catch (e) {
      throw InvalidBackupException(InvalidBackupReason.invalid, '$e');
    }
    if (json is! Map<String, dynamic>) {
      throw const InvalidBackupException(
        InvalidBackupReason.invalid,
        'not a JSON object',
      );
    }
    // Checked first: a newer format may have another structure.
    final version = json['formatVersion'];
    if (version is! int) {
      throw const InvalidBackupException(
        InvalidBackupReason.invalid,
        'missing formatVersion',
      );
    }
    if (version != BackupDto.currentFormatVersion) {
      throw InvalidBackupException(
        InvalidBackupReason.unsupportedVersion,
        'formatVersion $version',
      );
    }

    // Format v1 only has integers: the generated code would truncate a
    // decimal amount (`num.toInt()`).
    if (_containsDecimal(json)) {
      throw const InvalidBackupException(
        InvalidBackupReason.invalid,
        'decimal number',
      );
    }

    final BackupDto backup;
    try {
      backup = BackupDto.fromJson(json);
      // Malformed date or instant, missing field or wrong type (cast),
      // impossible date (LocalDay).
    } on FormatException catch (e) {
      throw InvalidBackupException(InvalidBackupReason.invalid, '$e');
    } on TypeError catch (e) {
      throw InvalidBackupException(InvalidBackupReason.invalid, '$e');
    } on ArgumentError catch (e) {
      throw InvalidBackupException(InvalidBackupReason.invalid, '$e');
    }
    BackupValidator.validate(backup);
    return backup;
  }

  static bool _containsDecimal(Object? json) => switch (json) {
    double() => true,
    Map<String, dynamic>() => json.values.any(_containsDecimal),
    List<dynamic>() => json.any(_containsDecimal),
    _ => false,
  };

  /// Replaces all the data and the currency with a backup checked by
  /// [decode], in one transaction: all or nothing (RG-51, ENF-06).
  Future<void> restore(BackupDto backup) {
    BackupValidator.validate(backup);
    final currency = Currency.fromCode(backup.currency)!;
    return _database.transaction(() async {
      // Cascades to loans and repayments, but deleting each table keeps it
      // explicit.
      await _database.delete(_database.repayments).go();
      await _database.delete(_database.loans).go();
      await _database.delete(_database.borrowers).go();

      await _database.batch((batch) {
        batch
          ..insertAll(_database.borrowers, [
            for (final borrower in backup.borrowers)
              BorrowersCompanion.insert(
                id: Value(borrower.id),
                name: borrower.name.trim(),
                nameKey: borrowerNameKey(borrower.name),
                phone: Value(borrower.phone),
                note: Value(borrower.note),
                createdAt: borrower.createdAt,
              ),
          ])
          ..insertAll(_database.loans, [
            for (final loan in backup.loans)
              LoansCompanion.insert(
                id: Value(loan.id),
                borrowerId: loan.borrowerId,
                amountMinor: loan.amountMinor,
                loanDate: loan.loanDate,
                promisedReturnDate: Value(loan.promisedReturnDate),
                note: Value(loan.note),
              ),
          ])
          ..insertAll(_database.repayments, [
            for (final repayment in backup.repayments)
              RepaymentsCompanion.insert(
                id: Value(repayment.id),
                loanId: repayment.loanId,
                amountMinor: repayment.amountMinor,
                repaymentDate: repayment.repaymentDate,
                note: Value(repayment.note),
              ),
          ]);
      });

      // Last, so that a failure rolls the data back: amounts are in minor
      // units of the backup currency.
      await _settings.setCurrency(currency);
    });
  }
}
