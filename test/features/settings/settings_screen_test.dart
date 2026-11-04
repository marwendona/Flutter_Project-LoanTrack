import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/features/settings/currency_controller.dart';
import 'package:loantrack/features/settings/settings_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoanRepository extends Mock implements LoanRepository {}

void main() {
  const lockedMessage =
      'La devise ne peut plus être modifiée une fois des prêts enregistrés';

  late InMemorySettingsStore settings;
  late _MockLoanRepository loans;

  setUp(() {
    settings = InMemorySettingsStore();
    loans = _MockLoanRepository();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    required bool hasLoans,
    ThemeData? theme,
  }) async {
    when(() => loans.hasAny()).thenAnswer((_) async => hasLoans);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsStoreProvider.overrideWithValue(settings),
          loanRepositoryProvider.overrideWithValue(loans),
          currencyLockedProvider.overrideWith((ref) => Stream.value(hasLoans)),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          theme: theme ?? AppTheme.light(null),
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows TND by default (RG-40)', (tester) async {
    await pumpScreen(tester, hasLoans: false);

    expect(find.text('Devise'), findsOneWidget);
    expect(find.text('TND — Dinar tunisien'), findsOneWidget);
    expect(find.textContaining(lockedMessage), findsNothing);
  });

  testWidgets('chooses another currency while no loan exists', (tester) async {
    await pumpScreen(tester, hasLoans: false);

    await tester.tap(find.text('Devise'));
    await tester.pumpAndSettle();
    expect(find.text('Choisir la devise'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(Currency.supported.length + 1));

    await tester.tap(find.text('EUR — Euro'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir la devise'), findsNothing);
    expect(find.text('EUR — Euro'), findsOneWidget);
    expect(settings.currency, const Currency(code: 'EUR', decimals: 2));
  });

  testWidgets('is read-only with an explanation once a loan exists (RG-41)', (
    tester,
  ) async {
    await pumpScreen(tester, hasLoans: true);

    expect(find.textContaining('TND — Dinar tunisien'), findsOneWidget);
    expect(find.textContaining(lockedMessage), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);

    await tester.tap(find.text('Devise'));
    await tester.pumpAndSettle();
    expect(find.text('Choisir la devise'), findsNothing);
    expect(settings.currency, Currency.tnd);
  });

  testWidgets('renders in dark mode', (tester) async {
    await pumpScreen(tester, hasLoans: true, theme: AppTheme.dark(null));

    expect(find.textContaining(lockedMessage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
