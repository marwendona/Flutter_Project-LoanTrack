import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/data/database/app_database.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/features/settings/currency_controller.dart';

void main() {
  const eur = Currency(code: 'EUR', decimals: 2);

  late InMemorySettingsStore settings;
  late ProviderContainer container;

  setUp(() {
    settings = InMemorySettingsStore();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final db = AppDatabase(NativeDatabase.memory());
          ref.onDispose(db.close);
          return db;
        }),
        settingsStoreProvider.overrideWithValue(settings),
      ],
    );
  });
  tearDown(() => container.dispose());

  Future<int> addLoan() async {
    final borrowerId = await container
        .read(borrowerRepositoryProvider)
        .add(name: 'Ali');
    return container
        .read(loanRepositoryProvider)
        .add(
          borrowerId: borrowerId,
          amount: const Money(1000),
          loanDate: LocalDay(2026, 10, 1),
        );
  }

  test('starts with the saved currency, TND by default (RG-40)', () {
    expect(container.read(currencyControllerProvider), Currency.tnd);
    expect(container.read(currencyProvider), Currency.tnd);
  });

  test('changes and saves the currency while no loan exists', () async {
    await container.read(currencyControllerProvider.notifier).change(eur);

    expect(settings.currency, eur);
    expect(container.read(currencyProvider), eur);
    expect(container.read(currencyControllerProvider), eur);
  });

  test('refuses the change once a loan exists (RG-41)', () async {
    await addLoan();

    await expectLater(
      container.read(currencyControllerProvider.notifier).change(eur),
      throwsA(isA<CurrencyLockedException>()),
    );
    expect(settings.currency, Currency.tnd);
    expect(container.read(currencyProvider), Currency.tnd);
  });

  test('currencyLockedProvider follows the loans (RG-41)', () async {
    final repository = container.read(loanRepositoryProvider);
    // Listened, otherwise Riverpod pauses the provider.
    container.listen(currencyLockedProvider, (_, _) {});
    Future<bool> locked() async {
      await pumpEventQueue();
      return container.read(currencyLockedProvider.future);
    }

    expect(await repository.hasAny(), isFalse);
    expect(await locked(), isFalse);

    final loanId = await addLoan();
    expect(await repository.hasAny(), isTrue);
    expect(await locked(), isTrue);

    await repository.delete(loanId);
    expect(await repository.hasAny(), isFalse);
    expect(await locked(), isFalse);
  });
}
