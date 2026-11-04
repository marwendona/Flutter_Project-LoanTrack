import 'package:shared_preferences/shared_preferences.dart';

import '../../core/money/currency.dart';

/// The user settings (ECR-06), read synchronously once loaded at startup.
abstract interface class SettingsStore {
  /// The app currency, TND when none was saved or the saved code is unknown
  /// (RG-40).
  Currency get currency;

  Future<void> setCurrency(Currency currency);
}

/// [SettingsStore] backed by `shared_preferences`.
class SharedPreferencesSettingsStore implements SettingsStore {
  SharedPreferencesSettingsStore(this._preferences);

  static const currencyKey = 'currency';

  final SharedPreferences _preferences;

  @override
  Currency get currency =>
      Currency.fromCode(_preferences.getString(currencyKey)) ?? Currency.tnd;

  @override
  Future<void> setCurrency(Currency currency) async {
    final saved = await _preferences.setString(currencyKey, currency.code);
    if (!saved) throw StateError('Currency ${currency.code} not saved');
  }
}

/// Non-persistent [SettingsStore], the default of `settingsStoreProvider` so
/// that tests do not need `shared_preferences`; `main` overrides it.
class InMemorySettingsStore implements SettingsStore {
  InMemorySettingsStore([this._currency = Currency.tnd]);

  Currency _currency;

  @override
  Currency get currency => _currency;

  @override
  Future<void> setCurrency(Currency currency) async => _currency = currency;
}
