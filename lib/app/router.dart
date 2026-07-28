import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';

class AppRouter {
  AppRouter._();

  static const String dashboardPath = '/';

  static final GoRouter router = GoRouter(
    initialLocation: dashboardPath,
    routes: [
      GoRoute(
        path: dashboardPath,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
