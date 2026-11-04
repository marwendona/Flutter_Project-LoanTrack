import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/money/currency.dart';
import '../domain/repositories/borrower_repository.dart';
import '../domain/repositories/loan_repository.dart';
import '../domain/repositories/repayment_repository.dart';
import 'database/app_database.dart';
import 'repositories/borrower_repository_impl.dart';
import 'repositories/loan_repository_impl.dart';
import 'repositories/repayment_repository_impl.dart';
import 'settings/settings_store.dart';

/// The single app database. Override it in tests with
/// `AppDatabase(NativeDatabase.memory())`.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(openAppDatabaseConnection());
  ref.onDispose(database.close);
  return database;
});

/// The user settings. In memory by default (tests); `main` overrides it with
/// a [SharedPreferencesSettingsStore] loaded at startup.
final settingsStoreProvider = Provider<SettingsStore>(
  (ref) => InMemorySettingsStore(),
);

/// The app currency (RG-40), read from the settings. Invalidate it after
/// changing the saved currency.
final currencyProvider = Provider<Currency>(
  (ref) => ref.watch(settingsStoreProvider).currency,
);

final borrowerRepositoryProvider = Provider<BorrowerRepository>(
  (ref) => BorrowerRepositoryImpl(ref.watch(appDatabaseProvider).borrowersDao),
);

final loanRepositoryProvider = Provider<LoanRepository>(
  (ref) => LoanRepositoryImpl(ref.watch(appDatabaseProvider).loansDao),
);

final repaymentRepositoryProvider = Provider<RepaymentRepository>(
  (ref) =>
      RepaymentRepositoryImpl(ref.watch(appDatabaseProvider).repaymentsDao),
);
