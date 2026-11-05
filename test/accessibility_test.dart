// US-6.2 / ENF-08: every screen meets the Flutter accessibility guidelines
// (tap targets >= 48 dp, labelled tap targets, text contrast) in light and
// dark mode, and renders without overflow with the system font enlarged.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/core/money/money.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/data/settings/settings_store.dart';
import 'package:loantrack/domain/models/borrower.dart';
import 'package:loantrack/domain/models/borrower_summary.dart';
import 'package:loantrack/domain/models/global_totals.dart';
import 'package:loantrack/domain/models/loan.dart';
import 'package:loantrack/domain/models/loan_status.dart';
import 'package:loantrack/domain/models/loan_summary.dart';
import 'package:loantrack/domain/models/repayment.dart';
import 'package:loantrack/features/borrower_detail/borrower_detail_providers.dart';
import 'package:loantrack/features/borrower_detail/borrower_detail_screen.dart';
import 'package:loantrack/features/borrowers/borrower_form_sheet.dart';
import 'package:loantrack/features/borrowers/borrowers_providers.dart';
import 'package:loantrack/features/borrowers/borrowers_screen.dart';
import 'package:loantrack/features/dashboard/dashboard_providers.dart';
import 'package:loantrack/features/dashboard/dashboard_screen.dart';
import 'package:loantrack/features/loan/loan_form_screen.dart';
import 'package:loantrack/features/loan_detail/loan_detail_providers.dart';
import 'package:loantrack/features/loan_detail/loan_detail_screen.dart';
import 'package:loantrack/features/repayment/repayment_form_sheet.dart';
import 'package:loantrack/features/settings/app_version_provider.dart';
import 'package:loantrack/features/settings/currency_controller.dart';
import 'package:loantrack/features/settings/settings_screen.dart';
import 'package:loantrack/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  final createdAt = LocalDay(2026, 9, 1);
  final borrower = Borrower(
    id: 1,
    name: 'Mohamed Ben Abdallah',
    phone: '20 000 000',
    note: 'Voisin',
    createdAt: createdAt,
  );

  BorrowerSummary summary(Borrower b, {int overdue = 1}) => BorrowerSummary(
    borrower: b,
    totalLent: const Money(12345678),
    totalRepaid: const Money(1250500),
    loanCount: 2,
    activeLoanCount: 2,
    overdueLoanCount: overdue,
  );

  final summaries = [
    summary(borrower),
    summary(Borrower(id: 2, name: 'Sami', createdAt: createdAt), overdue: 0),
  ];

  const totals = GlobalTotals(
    totalLent: Money(24691356),
    totalRepaid: Money(2501000),
    loanCount: 4,
    borrowersWithRemainingCount: 2,
    overdueLoanCount: 1,
    overdueAmount: Money(11095178),
  );

  LoanSummary loanSummary(int id, {int repaid = 250000}) => LoanSummary(
    loan: Loan(
      id: id,
      borrowerId: 1,
      amount: const Money(12345678),
      loanDate: LocalDay(2026, 10, 1),
      promisedReturnDate: LocalDay(2026, 10, 25),
      note: 'Achat voiture',
    ),
    repaid: Money(repaid),
  );

  final BorrowerDetail borrowerDetail = (
    summary: summary(borrower),
    loans: [
      (summary: loanSummary(1), status: const LoanStatus.overdue(days: 12)),
      (summary: loanSummary(2), status: const LoanStatus.partiallyRepaid()),
      (
        summary: loanSummary(3, repaid: 12345678),
        status: LoanStatus.repaid(repaidOn: LocalDay(2026, 11, 2)),
      ),
    ],
  );

  final LoanDetail loanDetail = (
    summary: loanSummary(1),
    status: const LoanStatus.overdue(days: 12),
    repayments: [
      Repayment(
        id: 1,
        loanId: 1,
        amount: const Money(250000),
        repaymentDate: LocalDay(2026, 10, 15),
        note: 'Espèces',
      ),
    ],
  );

  final overrides = [
    settingsStoreProvider.overrideWithValue(InMemorySettingsStore()),
    currencyLockedProvider.overrideWith((ref) => Stream.value(true)),
    appVersionProvider.overrideWith((ref) async => (name: '1.0.0', code: '1')),
    globalTotalsProvider.overrideWith((ref) => Stream.value(totals)),
    borrowerSummariesProvider.overrideWith((ref) => Stream.value(summaries)),
    borrowerDetailProvider.overrideWith((ref, id) async => borrowerDetail),
    loanDetailProvider.overrideWith((ref, id) async => loanDetail),
  ];

  /// Opens [sheet] from a button, as the screens do.
  Widget sheetHost(Future<void> Function(BuildContext) sheet) => Scaffold(
    body: Builder(
      builder: (context) => Center(
        child: TextButton(
          onPressed: () => sheet(context),
          child: const Text('open'),
        ),
      ),
    ),
  );

  final screens = <String, Widget>{
    'ECR-01 dashboard': const DashboardScreen(),
    'ECR-02 borrowers': const BorrowersScreen(),
    'ECR-03 borrower detail': const BorrowerDetailScreen(borrowerId: 1),
    'ECR-04 loan form': const LoanFormScreen(borrowerId: 1),
    'ECR-05 loan detail': const LoanDetailScreen(borrowerId: 1, loanId: 1),
    'ECR-06 settings': const SettingsScreen(),
    'borrower form sheet': sheetHost(showBorrowerFormSheet),
    'repayment form sheet': sheetHost(
      (context) => showRepaymentFormSheet(context, loanSummary(1)),
    ),
    'repayment form sheet (edit)': sheetHost(
      (context) => showRepaymentFormSheet(
        context,
        loanSummary(1),
        existing: loanDetail.repayments.single,
      ),
    ),
  };

  Future<void> pumpScreen(
    WidgetTester tester,
    Widget home, {
    required ThemeData theme,
    double textScale = 1,
    bool tall = false,
  }) async {
    // Galaxy S22: 360 x 780 dp; [tall] builds the whole content of the lists.
    tester.view.physicalSize = Size(1080, tall ? 9000 : 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          theme: theme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (find.text('open').evaluate().isNotEmpty) {
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }
  }

  for (final MapEntry(key: name, value: screen) in screens.entries) {
    group(name, () {
      for (final (mode, theme) in [
        ('light', AppTheme.light(null)),
        ('dark', AppTheme.dark(null)),
      ]) {
        testWidgets('meets the accessibility guidelines ($mode)', (
          tester,
        ) async {
          final semantics = tester.ensureSemantics();
          await pumpScreen(tester, screen, theme: theme);

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          semantics.dispose();
        });
      }

      testWidgets('renders with the font enlarged x2 without overflow', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          screen,
          theme: AppTheme.light(null),
          textScale: 2,
          tall: true,
        );
        // Overflows are reported as exceptions and fail the test.
        expect(tester.takeException(), isNull);
      });
    });
  }

  testWidgets('loan statuses and the overdue badge are read as text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpScreen(
      tester,
      const BorrowerDetailScreen(borrowerId: 1),
      theme: AppTheme.light(null),
      tall: true,
    );

    // Each loan card is one tappable node whose label includes its status.
    expect(find.bySemanticsLabel(RegExp('En retard de 12 jours')), findsOne);
    expect(find.bySemanticsLabel(RegExp('Partiellement remboursé')), findsOne);
    expect(find.bySemanticsLabel(RegExp(r'\nRemboursé\n')), findsOne);

    await pumpScreen(
      tester,
      const BorrowersScreen(),
      theme: AppTheme.light(null),
    );
    expect(find.bySemanticsLabel(RegExp('En retard')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Reste dû')), findsNWidgets(2));
    semantics.dispose();
  });
}
