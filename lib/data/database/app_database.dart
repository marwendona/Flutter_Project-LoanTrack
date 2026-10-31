import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/date/local_day.dart';
import 'converters.dart';
import 'daos/borrowers_dao.dart';
import 'daos/loans_dao.dart';
import 'daos/repayments_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Borrowers, Loans, Repayments],
  daos: [BorrowersDao, LoansDao, RepaymentsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Increment on every schema change, export the schema to drift_schemas/
  /// and add a tested migration (ENF-07).
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      // Required for ON DELETE CASCADE (RG-03, RG-14).
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

/// Opens the app database file, in a background isolate.
QueryExecutor openAppDatabaseConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'loantrack.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
