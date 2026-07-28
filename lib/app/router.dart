import 'package:go_router/go_router.dart';

import '../features/account/presentation/account_screen.dart';
import '../features/account/presentation/account_form_screen.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/recurring/presentation/recurring_screen.dart';
import '../features/transaction/presentation/transaction_history_screen.dart';
import 'app_shell.dart';

class AppRouter {
  AppRouter._();

  static const String dashboardPath = '/';
  static const String historyPath = '/history';
  static const String planPath = '/plan';
  static const String profilePath = '/me';

  static final GoRouter router = GoRouter(
    initialLocation: dashboardPath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: dashboardPath,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: historyPath,
                builder: (context, state) => const TransactionHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: planPath,
                builder: (context, state) => const RecurringScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/accounts',
                builder: (context, state) {
                  return const AccountScreen();
                },
              ),
              GoRoute(
                path: '/accounts/new',
                builder: (context, state) {
                  return const AccountFormScreen();
                },
              ),
              GoRoute(
                path: '/accounts/:accountId/edit',
                builder: (context, state) {
                  final accountId = state.pathParameters['accountId']!;

                  return AccountFormScreen(
                    accountId: accountId,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
