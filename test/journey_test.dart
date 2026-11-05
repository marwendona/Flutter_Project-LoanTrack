// US-6.3: the main journey through the real app (router, screens,
// controllers, repositories and an in-memory Drift database): add a borrower,
// lend money, record a partial repayment, then check the dashboard totals.
import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/app.dart';
import 'package:loantrack/core/widgets/label_value_row.dart';
import 'package:loantrack/data/database/app_database.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/features/settings/app_version_provider.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  /// `1 500,000` → `1 500,000 TND` with the non-breaking spaces of
  /// MoneyFormatter.
  String tnd(String amount) => '$amount TND'.replaceAll(' ', ' ');

  /// Value of the first [LabelValueRow] labelled [label] in [scope], with
  /// non-breaking spaces as in [tnd].
  String valueOf(WidgetTester tester, String label, {Finder? scope}) => tester
      .widgetList<LabelValueRow>(
        scope == null
            ? find.byType(LabelValueRow)
            : find.descendant(of: scope, matching: find.byType(LabelValueRow)),
      )
      .firstWhere((row) => row.label == label)
      .value
      .replaceAll(RegExp(r'\s'), ' ');

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('borrower → loan → partial repayment → dashboard totals', (
    tester,
  ) async {
    // Galaxy S22: 360 x 780 dp.
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await withClock(Clock.fixed(DateTime(2026, 11, 5, 10)), () async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Closed with the ProviderScope, even when the test fails.
            appDatabaseProvider.overrideWith((ref) {
              final database = AppDatabase(NativeDatabase.memory());
              ref.onDispose(database.close);
              return database;
            }),
            settingsStoreProvider.overrideWithValue(InMemorySettingsStore()),
            appVersionProvider.overrideWith(
              (ref) async => (name: '1.0.0', code: '1'),
            ),
          ],
          child: const LoanTrackApp(),
        ),
      );
      await tester.pumpAndSettle();

      // ECR-01: nothing recorded yet.
      expect(find.text('Aucun prêt enregistré'), findsOneWidget);

      // ECR-02: add a borrower.
      await tapAndSettle(tester, find.text('Emprunteurs'));
      await tapAndSettle(tester, find.byTooltip('Ajouter un emprunteur'));
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nom'),
        'Mohamed Ben Ali',
      );
      await tapAndSettle(tester, find.text('Enregistrer'));
      expect(find.text('Nouvel emprunteur'), findsNothing);
      expect(find.text('Mohamed Ben Ali'), findsOneWidget);
      expect(find.text('Aucun prêt actif'), findsOneWidget);

      // ECR-03 → ECR-04: lend 1 500 TND today, no promised date.
      await tapAndSettle(tester, find.text('Mohamed Ben Ali'));
      expect(
        find.text('Aucun prêt. Appuyez sur « Prêt » pour en ajouter un.'),
        findsOneWidget,
      );
      await tapAndSettle(tester, find.text('Prêt'));
      expect(find.text('Nouveau prêt'), findsOneWidget);
      expect(find.text('05/11/2026'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Montant'),
        '1500',
      );
      await tester.pumpAndSettle();
      await tapAndSettle(tester, find.text('Enregistrer'));

      // Back on ECR-03 with the new loan.
      expect(find.text('Nouveau prêt'), findsNothing);
      expect(find.text('En cours'), findsOneWidget);
      expect(valueOf(tester, 'Total prêté'), tnd('1 500,000'));
      expect(valueOf(tester, 'Reste dû'), tnd('1 500,000'));

      // ECR-05 → ECR-05b: partial repayment of 375 TND.
      await tapAndSettle(tester, find.text('En cours'));
      expect(find.text('Détail du prêt'), findsOneWidget);
      expect(find.text('Aucun remboursement.'), findsOneWidget);
      await tapAndSettle(tester, find.text('Remboursement'));
      expect(find.text('Nouveau remboursement'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('Reste dû : ${tnd('1 500,000')}'),
        ),
        findsOneWidget,
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Montant remboursé'),
        '375',
      );
      await tester.pumpAndSettle();
      await tapAndSettle(tester, find.text('Enregistrer'));

      // ECR-05 updated: history, repaid, remaining and status.
      expect(find.text('Nouveau remboursement'), findsNothing);
      expect(find.text('Partiellement remboursé'), findsOneWidget);
      expect(find.text('Remboursé : ${tnd('375,000')}'), findsOneWidget);
      expect(find.text('Reste dû : ${tnd('1 125,000')}'), findsOneWidget);
      expect(valueOf(tester, '05/11/2026'), tnd('375,000'));

      // ECR-01: global totals and totals of the borrower.
      await tapAndSettle(tester, find.text('Tableau de bord').last);
      expect(find.text('Reste à recevoir'), findsOneWidget);
      expect(find.text(tnd('1 125,000')), findsWidgets);
      expect(find.text('Auprès de 1 emprunteur'), findsOneWidget);
      expect(valueOf(tester, 'Total prêté'), tnd('1 500,000'));
      expect(valueOf(tester, 'Total remboursé'), tnd('375,000'));
      expect(valueOf(tester, 'Taux de remboursement'), '25 %');
      expect(valueOf(tester, 'Aucun prêt en retard'), tnd('0,000'));

      await tester.scrollUntilVisible(find.text('Mohamed Ben Ali'), 200);
      final borrowerTile = find.ancestor(
        of: find.text('Mohamed Ben Ali'),
        matching: find.byType(InkWell),
      );
      String borrowerValue(String label) =>
          valueOf(tester, label, scope: borrowerTile);
      expect(borrowerValue('Total prêté'), tnd('1 500,000'));
      expect(borrowerValue('Total remboursé'), tnd('375,000'));
      expect(borrowerValue('Reste dû'), tnd('1 125,000'));
    });

    // Unmounts the app: cancels the database streams and closes the database.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
