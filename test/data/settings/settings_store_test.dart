import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<SharedPreferencesSettingsStore> store(
    Map<String, Object> values,
  ) async {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferencesSettingsStore(
      await SharedPreferences.getInstance(),
    );
  }

  test('currency defaults to TND when nothing is saved (RG-40)', () async {
    expect((await store({})).currency, Currency.tnd);
  });

  test('currency falls back to TND for an unknown saved code', () async {
    expect((await store({'currency': 'XYZ'})).currency, Currency.tnd);
  });

  test('saved currency is persisted in shared_preferences', () async {
    final settings = await store({});
    const eur = Currency(code: 'EUR', decimals: 2);

    await settings.setCurrency(eur);

    expect(settings.currency, eur);
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString(SharedPreferencesSettingsStore.currencyKey),
      'EUR',
    );
  });

  test(
    'in-memory store defaults to TND and keeps the chosen currency',
    () async {
      final settings = InMemorySettingsStore();
      expect(settings.currency, Currency.tnd);

      await settings.setCurrency(Currency.supported[1]);

      expect(settings.currency, Currency.supported[1]);
    },
  );
}
