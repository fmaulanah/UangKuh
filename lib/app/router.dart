import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
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
                path: profilePath,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
