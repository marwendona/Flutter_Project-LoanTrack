import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/backup/backup_dto.dart';
import 'package:loantrack/data/backup/backup_file_saver.dart';
import 'package:loantrack/data/backup/backup_service.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/features/settings/currency_controller.dart';
import 'package:loantrack/features/settings/settings_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoanRepository extends Mock implements LoanRepository {}

class _MockBackupFileSaver extends Mock implements BackupFileSaver {}

class _MockBackupService extends Mock implements BackupService {}

void main() {
  const lockedMessage =
      'La devise ne peut plus être modifiée une fois des prêts enregistrés';

  late InMemorySettingsStore settings;
  late _MockLoanRepository loans;
  late _MockBackupFileSaver saver;
  late _MockBackupService backupService;

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    settings = InMemorySettingsStore();
    loans = _MockLoanRepository();
    saver = _MockBackupFileSaver();
    backupService = _MockBackupService();
    when(backupService.createBackup).thenAnswer(
      (_) async => BackupDto(
        formatVersion: BackupDto.currentFormatVersion,
        exportedAt: DateTime.utc(2026, 11, 4),
        currency: 'TND',
        borrowers: const [],
        loans: const [],
        repayments: const [],
      ),
    );
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
          backupServiceProvider.overrideWithValue(backupService),
          backupFileSaverProvider.overrideWithValue(saver),
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
    expect(
      find.descendant(
        of: find.byType(SimpleDialog),
        matching: find.byType(ListTile),
      ),
      findsNWidgets(Currency.supported.length),
    );

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

  group('export (US-5.2)', () {
    void answerSave(Future<bool> Function() answer) {
      when(
        () => saver.save(
          fileName: any(named: 'fileName'),
          bytes: any(named: 'bytes'),
        ),
      ).thenAnswer((_) => answer());
    }

    testWidgets('shows a success message once saved', (tester) async {
      answerSave(() async => true);
      await pumpScreen(tester, hasLoans: false);

      await tester.tap(find.text('Exporter les données'));
      await tester.pumpAndSettle();

      expect(find.text('Données exportées'), findsOneWidget);
      verify(
        () => saver.save(
          fileName: any(named: 'fileName', that: endsWith('.json')),
          bytes: any(named: 'bytes'),
        ),
      ).called(1);
    });

    testWidgets('shows nothing when the file picker is cancelled', (
      tester,
    ) async {
      answerSave(() async => false);
      await pumpScreen(tester, hasLoans: false);

      await tester.tap(find.text('Exporter les données'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('shows a failure message', (tester) async {
      answerSave(() async => throw Exception('write failed'));
      await pumpScreen(tester, hasLoans: false);

      await tester.tap(find.text('Exporter les données'));
      await tester.pumpAndSettle();

      expect(find.text("L'export des données a échoué"), findsOneWidget);
    });
  });

  testWidgets('renders in dark mode', (tester) async {
    await pumpScreen(tester, hasLoans: true, theme: AppTheme.dark(null));

    expect(find.textContaining(lockedMessage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
