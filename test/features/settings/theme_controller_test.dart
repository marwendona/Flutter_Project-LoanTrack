import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/theme/app_theme_mode.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/features/settings/theme_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsStore extends Mock implements SettingsStore {}

void main() {
  ProviderContainer containerWith(SettingsStore settings) {
    final container = ProviderContainer(
      overrides: [settingsStoreProvider.overrideWithValue(settings)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('starts with the saved theme, system by default', () {
    expect(
      containerWith(InMemorySettingsStore()).read(themeControllerProvider),
      AppThemeMode.system,
    );
    expect(
      containerWith(InMemorySettingsStore(Currency.tnd, AppThemeMode.dark))
          .read(themeControllerProvider),
      AppThemeMode.dark,
    );
  });

  test('changes and saves the theme', () async {
    final settings = InMemorySettingsStore();
    final container = containerWith(settings);

    await container
        .read(themeControllerProvider.notifier)
        .change(AppThemeMode.light);

    expect(settings.themeMode, AppThemeMode.light);
    expect(container.read(themeControllerProvider), AppThemeMode.light);
  });

  test('keeps the current theme when saving fails', () async {
    final settings = _MockSettingsStore();
    when(() => settings.themeMode).thenReturn(AppThemeMode.system);
    when(() => settings.setThemeMode(AppThemeMode.dark))
        .thenThrow(StateError('not saved'));
    final container = containerWith(settings);

    await expectLater(
      container
          .read(themeControllerProvider.notifier)
          .change(AppThemeMode.dark),
      throwsStateError,
    );
    expect(container.read(themeControllerProvider), AppThemeMode.system);
  });
}
