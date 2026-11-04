import 'package:shared_preferences/shared_preferences.dart';

import '../../core/money/currency.dart';
import '../../core/theme/app_theme_mode.dart';

/// The user settings (ECR-06), read synchronously once loaded at startup.
abstract interface class SettingsStore {
  /// The app currency, TND when none was saved or the saved code is unknown
  /// (RG-40).
  Currency get currency;

  Future<void> setCurrency(Currency currency);

  /// The app theme, [AppThemeMode.system] when none was saved or the saved
  /// value is unknown.
  AppThemeMode get themeMode;

  Future<void> setThemeMode(AppThemeMode mode);
}

/// [SettingsStore] backed by `shared_preferences`.
class SharedPreferencesSettingsStore implements SettingsStore {
  SharedPreferencesSettingsStore(this._preferences);

  static const currencyKey = 'currency';
  static const themeModeKey = 'themeMode';

  final SharedPreferences _preferences;

  @override
  Currency get currency =>
      Currency.fromCode(_preferences.getString(currencyKey)) ?? Currency.tnd;

  @override
  Future<void> setCurrency(Currency currency) async {
    final saved = await _preferences.setString(currencyKey, currency.code);
    if (!saved) throw StateError('Currency ${currency.code} not saved');
  }

  @override
  AppThemeMode get themeMode =>
      AppThemeMode.fromName(_preferences.getString(themeModeKey));

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    final saved = await _preferences.setString(themeModeKey, mode.name);
    if (!saved) throw StateError('Theme mode ${mode.name} not saved');
  }
}

/// Non-persistent [SettingsStore], the default of `settingsStoreProvider` so
/// that tests do not need `shared_preferences`; `main` overrides it.
class InMemorySettingsStore implements SettingsStore {
  InMemorySettingsStore([
    this._currency = Currency.tnd,
    this._themeMode = AppThemeMode.system,
  ]);

  Currency _currency;
  AppThemeMode _themeMode;

  @override
  Currency get currency => _currency;

  @override
  Future<void> setCurrency(Currency currency) async => _currency = currency;

  @override
  AppThemeMode get themeMode => _themeMode;

  @override
  Future<void> setThemeMode(AppThemeMode mode) async => _themeMode = mode;
}
