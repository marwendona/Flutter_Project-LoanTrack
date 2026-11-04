import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/backup/backup_dto.dart';
import 'package:loantrack/data/backup/backup_file_picker.dart';
import 'package:loantrack/data/backup/backup_file_saver.dart';
import 'package:loantrack/data/backup/backup_service.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/domain/repositories/loan_repository.dart';
import 'package:loantrack/core/theme/app_theme_mode.dart';
import 'package:loantrack/features/settings/app_version_provider.dart';
import 'package:loantrack/features/settings/currency_controller.dart';
import 'package:loantrack/features/settings/settings_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoanRepository extends Mock implements LoanRepository {}

class _MockBackupFileSaver extends Mock implements BackupFileSaver {}

class _MockBackupFilePicker extends Mock implements BackupFilePicker {}

class _MockBackupService extends Mock implements BackupService {}

void main() {
  const lockedMessage =
      'La devise ne peut plus être modifiée une fois des prêts enregistrés';

  late InMemorySettingsStore settings;
  late _MockLoanRepository loans;
  late _MockBackupFileSaver saver;
  late _MockBackupFilePicker picker;
  late _MockBackupService backupService;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(
      BackupDto(
        formatVersion: BackupDto.currentFormatVersion,
        exportedAt: DateTime.utc(2026, 11, 4),
        currency: 'TND',
        borrowers: const [],
        loans: const [],
        repayments: const [],
      ),
    );
  });

  setUp(() {
    settings = InMemorySettingsStore();
    loans = _MockLoanRepository();
    saver = _MockBackupFileSaver();
    picker = _MockBackupFilePicker();
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
    Future<AppVersion> Function()? version,
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
          backupFilePickerProvider.overrideWithValue(picker),
          appVersionProvider.overrideWith(
            (ref) => (version ?? () async => (name: '1.0.0', code: '1'))(),
          ),
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

  group('import (US-5.3)', () {
    Uint8List fileOf(Map<String, Object?> json) =>
        Uint8List.fromList(utf8.encode(jsonEncode(json)));

    final validFile = fileOf({
      'formatVersion': 1,
      'exportedAt': '2026-11-04T09:30:00.000Z',
      'currency': 'TND',
      'borrowers': [
        for (final (id, name) in [(1, 'Ali'), (2, 'Sana')])
          {
            'id': id,
            'name': name,
            'phone': null,
            'note': null,
            'createdAt': '2026-10-01',
          },
      ],
      'loans': [
        {
          'id': 1,
          'borrowerId': 1,
          'amountMinor': 10000,
          'loanDate': '2026-10-01',
          'promisedReturnDate': null,
          'note': null,
        },
      ],
      'repayments': <Object>[],
    });

    setUp(() {
      when(() => backupService.restore(any())).thenAnswer((_) async {});
    });

    Future<void> tapImport(WidgetTester tester) async {
      await tester.tap(find.text('Importer des données'));
      await tester.pumpAndSettle();
    }

    testWidgets('previews the backup, then replaces the data once confirmed', (
      tester,
    ) async {
      when(() => picker.pick()).thenAnswer((_) async => validFile);
      await pumpScreen(tester, hasLoans: false);

      await tapImport(tester);

      expect(find.text('Remplacer toutes les données ?'), findsOneWidget);
      expect(
        find.textContaining(
          'Sauvegarde du 04/11/2026 : 2 emprunteurs, 1 prêt.',
        ),
        findsOneWidget,
      );
      verifyNever(() => backupService.restore(any()));

      await tester.tap(find.text('Remplacer'));
      await tester.pumpAndSettle();

      expect(find.text('Données importées'), findsOneWidget);
      final restored =
          verify(() => backupService.restore(captureAny())).captured.single
              as BackupDto;
      expect(restored.borrowers, hasLength(2));
    });

    testWidgets('changes nothing when the replacement is cancelled', (
      tester,
    ) async {
      when(() => picker.pick()).thenAnswer((_) async => validFile);
      await pumpScreen(tester, hasLoans: false);

      await tapImport(tester);
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      expect(find.text('Remplacer toutes les données ?'), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
      verifyNever(() => backupService.restore(any()));
    });

    testWidgets('shows nothing when the file picker is cancelled', (
      tester,
    ) async {
      when(() => picker.pick()).thenAnswer((_) async => null);
      await pumpScreen(tester, hasLoans: false);

      await tapImport(tester);

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('refuses an invalid file without modifying anything (RG-51)', (
      tester,
    ) async {
      when(
        () => picker.pick(),
      ).thenAnswer((_) async => Uint8List.fromList(utf8.encode('pas du json')));
      await pumpScreen(tester, hasLoans: false);

      await tapImport(tester);

      expect(
        find.text("Fichier invalide : aucune donnée n'a été modifiée"),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(() => backupService.restore(any()));
    });

    testWidgets('refuses an unknown format version (RG-51)', (tester) async {
      when(() => picker.pick())
          .thenAnswer((_) async => fileOf({'formatVersion': 2}));
      await pumpScreen(tester, hasLoans: false);

      await tapImport(tester);

      expect(
        find.text(
          "Version de fichier non prise en charge : aucune donnée n'a été "
          'modifiée',
        ),
        findsOneWidget,
      );
      verifyNever(() => backupService.restore(any()));
    });

    testWidgets('shows a failure message when the import fails', (
      tester,
    ) async {
      when(() => picker.pick()).thenAnswer((_) async => validFile);
      when(() => backupService.restore(any()))
          .thenAnswer((_) async => throw Exception('write failed'));
      await pumpScreen(tester, hasLoans: false);

      await tapImport(tester);
      await tester.tap(find.text('Remplacer'));
      await tester.pumpAndSettle();

      expect(find.text("L'import des données a échoué"), findsOneWidget);
    });

    testWidgets('renders the confirmation in dark mode', (tester) async {
      when(() => picker.pick()).thenAnswer((_) async => validFile);
      await pumpScreen(tester, hasLoans: false, theme: AppTheme.dark(null));

      await tapImport(tester);

      expect(find.text('Remplacer toutes les données ?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('theme (US-5.4)', () {
    testWidgets('shows Système by default', (tester) async {
      await pumpScreen(tester, hasLoans: false);

      expect(find.text('Thème'), findsOneWidget);
      expect(find.text('Système'), findsOneWidget);
    });

    testWidgets('chooses and saves another theme', (tester) async {
      await pumpScreen(tester, hasLoans: false);

      await tester.tap(find.text('Thème'));
      await tester.pumpAndSettle();
      expect(find.text('Choisir le thème'), findsOneWidget);
      final options = find.descendant(
        of: find.byType(SimpleDialog),
        matching: find.byType(ListTile),
      );
      expect(options, findsNWidgets(3));
      expect(
        find.descendant(of: options, matching: find.text('Clair')),
        findsOneWidget,
      );

      await tester.tap(find.text('Sombre'));
      await tester.pumpAndSettle();

      expect(find.text('Choisir le thème'), findsNothing);
      expect(find.text('Sombre'), findsOneWidget);
      expect(settings.themeMode, AppThemeMode.dark);
    });

    testWidgets('keeps the theme when the dialog is dismissed', (tester) async {
      await pumpScreen(tester, hasLoans: false);

      await tester.tap(find.text('Thème'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Choisir le thème'), findsNothing);
      expect(settings.themeMode, AppThemeMode.system);
    });
  });

  group('version (US-5.4)', () {
    testWidgets('shows the installed version', (tester) async {
      await pumpScreen(
        tester,
        hasLoans: false,
        version: () async => (name: '1.2.3', code: '7'),
      );

      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.2.3 (7)'), findsOneWidget);
    });

    testWidgets('shows Indisponible when the version cannot be read', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        hasLoans: false,
        version: () async => throw Exception('no platform'),
      );

      expect(find.text('Indisponible'), findsOneWidget);
    });
  });

  testWidgets('renders in dark mode', (tester) async {
    await pumpScreen(tester, hasLoans: true, theme: AppTheme.dark(null));

    expect(find.textContaining(lockedMessage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
