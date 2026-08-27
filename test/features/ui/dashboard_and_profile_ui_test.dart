import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uangkuh/features/auth/domain/app_session.dart';
import 'package:uangkuh/features/auth/providers/app_session_provider.dart';
import 'package:uangkuh/features/dashboard/presentation/dashboard_screen.dart';
import 'package:uangkuh/features/dashboard/providers/dashboard_total_balance_provider.dart';
import 'package:uangkuh/features/dashboard/providers/dashboard_monthly_summary_provider.dart';
import 'package:uangkuh/features/dashboard/domain/monthly_summary.dart';
import 'package:uangkuh/features/account/providers/account_list_provider.dart';
import 'package:uangkuh/features/recurring/providers/recurring_plan_provider.dart';
import 'package:uangkuh/features/transaction/providers/transaction_history_provider.dart';
import 'package:uangkuh/features/household/providers/household_profile_provider.dart';
import 'package:uangkuh/features/profile/presentation/profile_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  Widget createTestWidget({
    required Widget child,
    required List<dynamic> overrides,
  }) {
    return ProviderScope(
      overrides: overrides.cast(),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('id'),
        ],
        home: Scaffold(body: child),
      ),
    );
  }

  group('Dashboard Greeting UI Test', () {
    testWidgets('displays user display name when session exists',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const DashboardScreen(),
          overrides: [
            appSessionProvider.overrideWith(
              (ref) => const AppSession(
                userId: 'user123',
                householdId: 'h1',
                email: 'fikri@test.com',
                displayName: 'Fikri',
              ),
            ),
            dashboardTotalBalanceProvider.overrideWith((ref) => 0),
            dashboardMonthlySummaryProvider.overrideWith(
              (ref) => const MonthlySummary(income: 0, expense: 0),
            ),
            accountListProvider.overrideWith((ref) => []),
            recurringPlanProvider.overrideWith((ref) => []),
            transactionListProvider.overrideWith((ref) => []),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Fikri 👋'), findsOneWidget);
    });

    testWidgets('falls back to User when displayName is empty',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const DashboardScreen(),
          overrides: [
            appSessionProvider.overrideWith(
              (ref) => const AppSession(
                userId: 'user123',
                householdId: 'h1',
                email: 'user@test.com',
                displayName: '',
              ),
            ),
            dashboardTotalBalanceProvider.overrideWith((ref) => 0),
            dashboardMonthlySummaryProvider.overrideWith(
              (ref) => const MonthlySummary(income: 0, expense: 0),
            ),
            accountListProvider.overrideWith((ref) => []),
            recurringPlanProvider.overrideWith((ref) => []),
            transactionListProvider.overrideWith((ref) => []),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('User 👋'), findsOneWidget);
    });
  });

  group('Profile Screen Owner vs Member UI Test', () {
    testWidgets('displays invite code and copy button for owner',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const ProfileScreen(),
          overrides: [
            householdProfileProvider.overrideWith(
              (ref) => Future.value(
                const HouseholdProfileState(
                  householdId: 'h1',
                  name: 'Family Budget',
                  ownerId: 'user123',
                  isOwner: true,
                  inviteCode: 'FAM12345',
                ),
              ),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Family Budget'), findsOneWidget);
      expect(find.text('Invite Code'), findsOneWidget);
      expect(find.text('FAM12345'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
    });

    testWidgets('hides invite code for member', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const ProfileScreen(),
          overrides: [
            householdProfileProvider.overrideWith(
              (ref) => Future.value(
                const HouseholdProfileState(
                  householdId: 'h1',
                  name: 'Family Budget',
                  ownerId: 'ownerUser',
                  isOwner: false,
                  inviteCode: null,
                ),
              ),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Family Budget'), findsOneWidget);
      expect(find.text('Invite Code'), findsNothing);
      expect(find.text('Copy'), findsNothing);
    });
  });
}
