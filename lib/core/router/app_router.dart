import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/borrower_detail/borrower_detail_screen.dart';
import '../../features/borrowers/borrowers_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/loan/loan_form_screen.dart';
import '../../features/loan_detail/loan_detail_screen.dart';
import '../../features/settings/settings_screen.dart';
import 'scaffold_with_nav_bar.dart';

abstract final class AppRoutes {
  static const dashboard = '/dashboard';
  static const borrowers = '/borrowers';
  static const settings = '/settings';

  /// ECR-03 — Borrower detail (US-2.2).
  static String borrowerDetail(int borrowerId) => '$borrowers/$borrowerId';

  /// ECR-04 — New loan for a borrower (US-2.1).
  static String newLoan(int borrowerId) =>
      '${borrowerDetail(borrowerId)}/loans/new';

  /// ECR-05 — Loan detail with its repayments (US-3.2).
  static String loanDetail(int borrowerId, int loanId) =>
      '${borrowerDetail(borrowerId)}/loans/$loanId';

  /// ECR-04 — Modification of a loan (US-2.4).
  static String editLoan(int borrowerId, int loanId) =>
      '${borrowerDetail(borrowerId)}/loans/$loanId/edit';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

int _borrowerId(GoRouterState state) =>
    int.parse(state.pathParameters['borrowerId']!);

int _loanId(GoRouterState state) => int.parse(state.pathParameters['loanId']!);

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    routes: [
      // One branch per bottom navigation tab, each keeping its own stack.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.borrowers,
                builder: (context, state) => const BorrowersScreen(),
                routes: [
                  GoRoute(
                    path: ':borrowerId',
                    builder: (context, state) =>
                        BorrowerDetailScreen(borrowerId: _borrowerId(state)),
                    routes: [
                      GoRoute(
                        path: 'loans/new',
                        // Full screen form, above the bottom navigation bar.
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            LoanFormScreen(borrowerId: _borrowerId(state)),
                      ),
                      GoRoute(
                        path: 'loans/:loanId/edit',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => LoanFormScreen(
                          borrowerId: _borrowerId(state),
                          loanId: _loanId(state),
                        ),
                      ),
                      GoRoute(
                        path: 'loans/:loanId',
                        builder: (context, state) => LoanDetailScreen(
                          borrowerId: _borrowerId(state),
                          loanId: _loanId(state),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
