import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/app.dart';
import 'package:loantrack/domain/models/global_totals.dart';
import 'package:loantrack/features/borrowers/borrowers_providers.dart';
import 'package:loantrack/features/dashboard/dashboard_providers.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // No database in this navigation test.
          borrowerSummariesProvider.overrideWith((ref) => Stream.value([])),
          globalTotalsProvider.overrideWith(
            (ref) => Stream.value(GlobalTotals.empty),
          ),
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
}
