import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/app.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/theme/app_theme_mode.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/domain/models/global_totals.dart';
import 'package:loantrack/features/borrowers/borrowers_providers.dart';
import 'package:loantrack/features/dashboard/dashboard_providers.dart';
import 'package:loantrack/features/settings/app_version_provider.dart';
import 'package:loantrack/features/settings/currency_controller.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    AppThemeMode themeMode = AppThemeMode.system,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsStoreProvider.overrideWithValue(
            InMemorySettingsStore(Currency.tnd, themeMode),
          ),
          appVersionProvider.overrideWith(
            (ref) async => (name: '1.0.0', code: '1'),
          ),
          // No database in this navigation test.
          borrowerSummariesProvider.overrideWith((ref) => Stream.value([])),
          globalTotalsProvider.overrideWith(
            (ref) => Stream.value(GlobalTotals.empty),
          ),
          currencyLockedProvider.overrideWith((ref) => Stream.value(false)),
        ],
        child: const LoanTrackApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder appBarTitle(String text) =>
      find.descendant(of: find.byType(AppBar), matching: find.text(text));

  testWidgets('opens on the dashboard with three tabs', (tester) async {
    await pumpApp(tester);

    final navigationBar = find.byType(NavigationBar);
    expect(navigationBar, findsOneWidget);
    expect(
      find.descendant(
        of: navigationBar,
        matching: find.byType(NavigationDestination),
      ),
      findsNWidgets(3),
    );
    expect(appBarTitle('Tableau de bord'), findsOneWidget);
  });

  testWidgets('navigates between tabs', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Emprunteurs'));
    await tester.pumpAndSettle();
    expect(appBarTitle('Emprunteurs'), findsOneWidget);

    await tester.tap(find.text('Paramètres'));
    await tester.pumpAndSettle();
    expect(appBarTitle('Paramètres'), findsOneWidget);

    await tester.tap(find.text('Tableau de bord').last);
    await tester.pumpAndSettle();
    expect(appBarTitle('Tableau de bord'), findsOneWidget);
  });

  group('theme (US-5.4)', () {
    ThemeMode appThemeMode(WidgetTester tester) =>
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;

    testWidgets('follows the system by default', (tester) async {
      await pumpApp(tester);
      expect(appThemeMode(tester), ThemeMode.system);
    });

    testWidgets('applies the saved theme', (tester) async {
      await pumpApp(tester, themeMode: AppThemeMode.dark);
      expect(appThemeMode(tester), ThemeMode.dark);
      expect(
        Theme.of(tester.element(find.byType(NavigationBar))).brightness,
        Brightness.dark,
      );
    });

    testWidgets('applies a theme chosen in the settings immediately', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.text('Paramètres'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thème'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clair'));
      await tester.pumpAndSettle();

      expect(appThemeMode(tester), ThemeMode.light);
    });
  });
}
