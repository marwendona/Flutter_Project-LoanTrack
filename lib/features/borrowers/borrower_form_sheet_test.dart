import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/repositories/borrower_repository.dart';
import 'package:loantrack/domain/services/borrower_validator.dart';
import 'package:loantrack/features/borrowers/borrowers_providers.dart';
import 'package:loantrack/features/borrowers/borrowers_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockBorrowerRepository extends Mock implements BorrowerRepository {}

void main() {
  late _MockBorrowerRepository repository;

  setUp(() => repository = _MockBorrowerRepository());

  Future<void> openForm(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          borrowerRepositoryProvider.overrideWithValue(repository),
          borrowerSummariesProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          theme: AppTheme.light(null),
          home: const BorrowersScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ajouter un emprunteur'));
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('"+" opens the new borrower form', (tester) async {
    await openForm(tester);

    expect(find.text('Nouvel emprunteur'), findsOneWidget);
    expect(field('Nom'), findsOneWidget);
    expect(field('Téléphone (facultatif)'), findsOneWidget);
    expect(field('Note (facultative)'), findsOneWidget);
  });

  testWidgets('requires a name (RG-01)', (tester) async {
    await openForm(tester);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.text('Le nom est obligatoire.'), findsOneWidget);
    expect(find.text('Nouvel emprunteur'), findsOneWidget);
  });

  testWidgets('saves the borrower and closes the form', (tester) async {
    when(
      () => repository.add(
        name: any(named: 'name'),
        phone: any(named: 'phone'),
        note: any(named: 'note'),
      ),
    ).thenAnswer((_) async => 1);
    await openForm(tester);

    await tester.enterText(field('Nom'), ' Ali ');
    await tester.enterText(field('Téléphone (facultatif)'), '20 000 000');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    verify(() => repository.add(name: ' Ali ', phone: '20 000 000', note: ''))
        .called(1);
    expect(find.text('Nouvel emprunteur'), findsNothing);
  });

  testWidgets('shows the duplicate name message (RG-02)', (tester) async {
    when(
      () => repository.add(
        name: any(named: 'name'),
        phone: any(named: 'phone'),
        note: any(named: 'note'),
      ),
    ).thenThrow(const DuplicateBorrowerNameException('Ali'));
    await openForm(tester);

    await tester.enterText(field('Nom'), 'Ali');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.text('Un emprunteur porte déjà ce nom.'), findsOneWidget);
    expect(find.text('Nouvel emprunteur'), findsOneWidget);

    await tester.enterText(field('Nom'), 'Ali B.');
    await tester.pumpAndSettle();
    expect(find.text('Un emprunteur porte déjà ce nom.'), findsNothing);
  });
}
