import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/borrowers/borrowers_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/loan/loan_form_screen.dart';
import '../../features/settings/settings_screen.dart';
import 'scaffold_with_nav_bar.dart';

abstract final class AppRoutes {
  static const dashboard = '/dashboard';
  static const borrowers = '/borrowers';
  static const settings = '/settings';

  /// ECR-04 — New loan for a borrower (US-2.1).
  static String newLoan(int borrowerId) => '$borrowers/$borrowerId/loans/new';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

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
                    path: ':borrowerId/loans/new',
                    // Full screen form, above the bottom navigation bar.
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => LoanFormScreen(
                      borrowerId: int.parse(
                        state.pathParameters['borrowerId']!,
                      ),
                    ),
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
