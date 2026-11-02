import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/money/currency.dart';
import '../domain/repositories/borrower_repository.dart';
import '../domain/repositories/loan_repository.dart';
import '../domain/repositories/repayment_repository.dart';
import 'database/app_database.dart';
import 'repositories/borrower_repository_impl.dart';
import 'repositories/loan_repository_impl.dart';
import 'repositories/repayment_repository_impl.dart';

/// The single app database. Override it in tests with
/// `AppDatabase(NativeDatabase.memory())`.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(openAppDatabaseConnection());
  ref.onDispose(database.close);
  return database;
});

/// The app currency (RG-40). TND for now: it will be read from the settings
/// once the currency choice exists (epic E5).
final currencyProvider = Provider<Currency>((ref) => Currency.tnd);

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
