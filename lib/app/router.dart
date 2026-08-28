import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/router/go_router_refresh_stream.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';

import '../features/account/presentation/account_form_screen.dart';
import '../features/account/presentation/account_screen.dart';

import '../features/category/presentation/category_screen.dart';
import '../features/category/presentation/category_form_screen.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';

import '../features/profile/presentation/profile_screen.dart';

import '../features/recurring/presentation/recurring_screen.dart';
import '../features/recurring/presentation/recurring_form_screen.dart';
import '../features/recurring/presentation/recurring_payment_screen.dart';

import '../features/transaction/presentation/transaction_history_screen.dart';
import '../features/transaction/presentation/expense_form_screen.dart';
import '../features/transaction/presentation/income_form_screen.dart';
import '../features/transaction/presentation/transfer_form_screen.dart';
import '../features/transaction/presentation/transaction_detail_screen.dart';
import '../features/transaction/presentation/models/transaction_list_item.dart';
import '../features/transaction/presentation/adjustment_form_screen.dart';

import '../features/receipt_scanner/presentation/receipt_scanner_screen.dart';

import 'app_shell.dart';

class AppRouter {
  AppRouter._();

  static const String loginPath = '/login';
  static const String registerPath = '/register';

  static const String dashboardPath = '/';
  static const String historyPath = '/history';
  static const String planPath = '/plan';
  static const String profilePath = '/me';

  static final GoRouter router = GoRouter(
    initialLocation: dashboardPath,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;

      final isAuthPage = state.matchedLocation == loginPath ||
          state.matchedLocation == registerPath;

      if (user == null) {
        return isAuthPage ? null : loginPath;
      }

      if (isAuthPage) {
        return dashboardPath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: loginPath,
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) {
          return const RegisterPage();
        },
      ),
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
                builder: (context, state) {
                  return const DashboardScreen();
                },
                routes: [
                  GoRoute(
                    path: 'expense/new',
                    builder: (context, state) {
                      return const ExpenseFormScreen();
                    },
                  ),
                  GoRoute(
                    path: 'income/new',
                    builder: (context, state) {
                      return const IncomeFormScreen();
                    },
                  ),
                  GoRoute(
                    path: 'transfer/new',
                    builder: (context, state) {
                      return const TransferFormScreen();
                    },
                  ),
                  GoRoute(
                    path: 'adjustment/new',
                    builder: (context, state) {
                      return const AdjustmentFormScreen();
                    },
                  ),
                  GoRoute(
                    path: 'receipt/scan',
                    builder: (context, state) {
                      return const ReceiptScannerScreen();
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: historyPath,
                builder: (context, state) {
                  return const TransactionHistoryScreen();
                },
                routes: [
                  GoRoute(
                    path: 'transaction',
                    builder: (context, state) {
                      final transaction = state.extra as TransactionListItem;

                      return TransactionDetailScreen(
                        transaction: transaction,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: planPath,
                builder: (context, state) {
                  return const RecurringScreen();
                },
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) {
                      return const RecurringFormScreen();
                    },
                  ),
                  GoRoute(
                    path: ':recurringId/edit',
                    builder: (context, state) {
                      final recurringId = state.pathParameters['recurringId']!;

                      return RecurringFormScreen(
                        recurringId: recurringId,
                      );
                    },
                  ),
                  GoRoute(
                    path: ':recurringId/pay',
                    builder: (context, state) {
                      final recurringId = state.pathParameters['recurringId']!;

                      return RecurringPaymentScreen(
                        recurringId: recurringId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                builder: (context, state) {
                  return const ProfileScreen();
                },
                routes: [
                  GoRoute(
                    path: 'accounts',
                    builder: (context, state) {
                      return const AccountScreen();
                    },
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (context, state) {
                          return const AccountFormScreen();
                        },
                      ),
                      GoRoute(
                        path: ':accountId/edit',
                        builder: (context, state) {
                          final accountId = state.pathParameters['accountId']!;

                          return AccountFormScreen(
                            accountId: accountId,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'categories',
                    builder: (context, state) {
                      return const CategoryScreen();
                    },
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (context, state) {
                          return const CategoryFormScreen();
                        },
                      ),
                      GoRoute(
                        path: ':categoryId/edit',
                        builder: (context, state) {
                          final categoryId =
                              state.pathParameters['categoryId']!;

                          return CategoryFormScreen(
                            categoryId: categoryId,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
