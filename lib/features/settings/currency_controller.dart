import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money/currency.dart';
import '../../data/providers.dart';

/// The currency cannot change once a loan exists (RG-41).
class CurrencyLockedException implements Exception {
  const CurrencyLockedException();

  @override
  String toString() => 'CurrencyLockedException';
}

/// Whether the currency is locked because at least one loan exists (RG-41).
final currencyLockedProvider = StreamProvider<bool>(
  (ref) => ref.watch(loanRepositoryProvider).watchHasAny(),
);

/// The currency setting of ECR-06 (RG-40, RG-41).
final currencyControllerProvider =
    NotifierProvider<CurrencyController, Currency>(CurrencyController.new);

class CurrencyController extends Notifier<Currency> {
  @override
  Currency build() => ref.watch(currencyProvider);

  /// Saves [currency] as the app currency; throws [CurrencyLockedException]
  /// if a loan exists (RG-41).
  Future<void> change(Currency currency) async {
    if (currency == state) return;
    if (await ref.read(loanRepositoryProvider).hasAny()) {
      throw const CurrencyLockedException();
    }
    await ref.read(settingsStoreProvider).setCurrency(currency);
    ref.invalidate(currencyProvider);
  }
}
