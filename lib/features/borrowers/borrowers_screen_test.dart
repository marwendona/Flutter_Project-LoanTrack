import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/currency.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/money/money_formatter.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/core/widgets/overdue_badge.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/features/borrowers/borrowers_providers.dart';
import 'package:loantrack/features/borrowers/borrowers_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester,
    List<BorrowerSummary> summaries,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          borrowerSummariesProvider.overrideWith(
            (ref) => Stream.value(summaries),
          ),
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
  }

  // Formatted with non-breaking spaces: `1 000,000 TND`.
  String tnd(int amountMinor) =>
      MoneyFormatter.format(Money(amountMinor), Currency.tnd);

  BorrowerSummary summary(
    int id,
    String name, {
    required int lent,
    int repaid = 0,
    int active = 1,
    int overdue = 0,
  }) => BorrowerSummary(
    borrower: Borrower(id: id, name: name, createdAt: LocalDay(2026, 10, 1)),
    totalLent: Money(lent),
    totalRepaid: Money(repaid),
    loanCount: active,
    activeLoanCount: active,
    overdueLoanCount: overdue,
  );

  testWidgets('shows the empty state', (tester) async {
    await pumpScreen(tester, const []);

    expect(
      find.text('Aucun emprunteur. Appuyez sur + pour en ajouter un.'),
      findsOneWidget,
    );
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('shows name, remaining due, active loans and overdue badge', (
    tester,
  ) async {
    await pumpScreen(tester, [
      summary(1, 'Ali', lent: 1250500, repaid: 250500, active: 2, overdue: 1),
      summary(2, 'Sami', lent: 500000, repaid: 500000, active: 0),
    ]);

    final tiles = find.byType(ListTile);
    expect(tiles, findsNWidgets(2));

    final ali = tiles.at(0);
    expect(find.descendant(of: ali, matching: find.text('Ali')), findsOne);
    expect(
      find.descendant(of: ali, matching: find.text(tnd(1000000))),
      findsOne,
    );
    expect(
      find.descendant(of: ali, matching: find.text('2 prêts actifs')),
      findsOne,
    );
    expect(
      find.descendant(of: ali, matching: find.byType(OverdueBadge)),
      findsOne,
    );
    expect(find.text('En retard'), findsOneWidget);

    final sami = tiles.at(1);
    expect(find.descendant(of: sami, matching: find.text('Sami')), findsOne);
    expect(find.descendant(of: sami, matching: find.text(tnd(0))), findsOne);
    expect(
      find.descendant(of: sami, matching: find.text('Aucun prêt actif')),
      findsOne,
    );
    expect(
      find.descendant(of: sami, matching: find.byType(OverdueBadge)),
      findsNothing,
    );
  });
}
