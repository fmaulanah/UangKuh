import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extension.dart';

import '../../../app/theme.dart';
import '../../../app/widgets/app_amount_text.dart';
import '../../../app/widgets/app_section_header.dart';
import '../../../app/widgets/app_surface_card.dart';

import '../../account/domain/account_type.dart';
import '../../account/presentation/account_list_item.dart';
import '../../account/providers/account_list_provider.dart';

import '../../recurring/presentation/models/recurring_plan_item.dart';
import '../../recurring/providers/recurring_plan_provider.dart';

import '../../transaction/domain/transaction_type.dart';
import '../../transaction/presentation/models/transaction_list_item.dart';
import '../../transaction/providers/transaction_history_provider.dart';

import '../domain/monthly_summary.dart';
import '../providers/dashboard_monthly_summary_provider.dart';
import '../providers/dashboard_total_balance_provider.dart';
import '../../auth/providers/app_session_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final totalBalanceAsync = ref.watch(
      dashboardTotalBalanceProvider,
    );

    final accountListAsync = ref.watch(
      accountListProvider,
    );

    final monthlySummaryAsync = ref.watch(
      dashboardMonthlySummaryProvider,
    );

    final recentTransactionsAsync = ref.watch(
      transactionListProvider,
    );

    final recurringPlanAsync = ref.watch(
      recurringPlanProvider,
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(
            dashboardTotalBalanceProvider,
          );

          ref.invalidate(
            accountListProvider,
          );

          ref.invalidate(
            transactionHistoryProvider,
          );

          ref.invalidate(
            recurringPlanProvider,
          );

          await Future.wait([
            ref.read(
              dashboardTotalBalanceProvider.future,
            ),
            ref.read(
              accountListProvider.future,
            ),
            ref.read(
              dashboardMonthlySummaryProvider.future,
            ),
            ref.read(
              transactionListProvider.future,
            ),
            ref.read(
              recurringPlanProvider.future,
            ),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spaceMd,
            AppTheme.spaceLg,
            AppTheme.spaceMd,
            AppTheme.spaceXl,
          ),
          children: [
            _DashboardHeader(),
            const SizedBox(
              height: AppTheme.spaceLg,
            ),

            // Balance
            _DashboardBalanceCard(
              totalBalanceAsync: totalBalanceAsync,
            ),

            const SizedBox(
              height: AppTheme.spaceLg,
            ),

            // Quick Actions
            AppSectionHeader(
              title: context.l10n.quickActions,
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            _QuickActions(),

            const SizedBox(
              height: AppTheme.spaceLg,
            ),

            // Monthly Summary
            AppSectionHeader(
              title: context.l10n.thisMonth,
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            _MonthlySummaryCard(
              summaryAsync: monthlySummaryAsync,
            ),

            const SizedBox(
              height: AppTheme.spaceLg,
            ),

            // Accounts
            AppSectionHeader(
              title: context.l10n.accounts,
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            _AccountOverview(
              accountListAsync: accountListAsync,
            ),

            const SizedBox(
              height: AppTheme.spaceLg,
            ),

            // Plan
            AppSectionHeader(
              title: context.l10n.plan,
              actionLabel: context.l10n.viewPlan,
              onActionPressed: () {
                context.go('/plan');
              },
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            _RecurringPlanSummary(
              planAsync: recurringPlanAsync,
            ),

            const SizedBox(
              height: AppTheme.spaceLg,
            ),

            // Recent Transactions
            AppSectionHeader(
              title: context.l10n.recentTransactions,
              actionLabel: context.l10n.viewAll,
              onActionPressed: () {
                context.go('/history');
              },
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            _RecentTransactionsCard(
              transactionsAsync: recentTransactionsAsync,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Header
// -----------------------------------------------------------------------------

class _DashboardHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(appSessionProvider);
    final displayName = session?.displayName.trim();
    final nameToDisplay = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : 'User';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting(context)}, $nameToDisplay 👋',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: AppTheme.spaceXs,
              ),
              Text(
                context.l10n.yourMoneyAtAGlance,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(
              AppTheme.radiusLg,
            ),
          ),
          child: Icon(
            Icons.wallet_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Total Balance
// -----------------------------------------------------------------------------

class _DashboardBalanceCard extends StatelessWidget {
  const _DashboardBalanceCard({
    required this.totalBalanceAsync,
  });

  final AsyncValue<int> totalBalanceAsync;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppTheme.spaceLg,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(
          AppTheme.radiusXl,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTheme.radiusMd,
                  ),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(
                width: AppTheme.spaceMd,
              ),
              Expanded(
                child: Text(
                  context.l10n.totalBalance,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppTheme.spaceLg,
          ),
          totalBalanceAsync.when(
            loading: () => const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            error: (error, stackTrace) => Text(
              context.l10n.unableToLoadBalance,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            data: (balance) {
              return Text(
                _formatRupiah(balance),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              );
            },
          ),
          const SizedBox(
            height: AppTheme.spaceSm,
          ),
          Text(
            context.l10n.acrossAllAccounts,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Quick Actions
// -----------------------------------------------------------------------------

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.arrow_upward_rounded,
            label: context.l10n.expense,
            tone: _QuickActionTone.expense,
            onPressed: () {
              context.push('/expense/new');
            },
          ),
        ),
        const SizedBox(
          width: AppTheme.spaceSm,
        ),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.arrow_downward_rounded,
            label: context.l10n.income,
            tone: _QuickActionTone.income,
            onPressed: () {
              context.push('/income/new');
            },
          ),
        ),
        const SizedBox(
          width: AppTheme.spaceSm,
        ),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.swap_horiz_rounded,
            label: context.l10n.transfer,
            tone: _QuickActionTone.normal,
            onPressed: () {
              context.push('/transfer/new');
            },
          ),
        ),
        const SizedBox(
          width: AppTheme.spaceSm,
        ),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.tune_rounded,
            label: context.l10n.adjust,
            tone: _QuickActionTone.normal,
            onPressed: () {
              context.push('/adjustment/new');
            },
          ),
        ),
      ],
    );
  }
}

enum _QuickActionTone {
  expense,
  income,
  normal,
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.tone,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final _QuickActionTone tone;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final foregroundColor = switch (tone) {
      _QuickActionTone.expense => AppTheme.danger,
      _QuickActionTone.income => AppTheme.success,
      _QuickActionTone.normal => colorScheme.primary,
    };

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(
        AppTheme.radiusLg,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spaceSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: foregroundColor.withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(
                  AppTheme.radiusLg,
                ),
              ),
              child: Icon(
                icon,
                color: foregroundColor,
                size: 23,
              ),
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Monthly Summary
// -----------------------------------------------------------------------------

class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard({
    required this.summaryAsync,
  });

  final AsyncValue<MonthlySummary> summaryAsync;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _monthYearLabel(
              context,
              DateTime.now(),
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(
            height: AppTheme.spaceMd,
          ),
          summaryAsync.when(
            loading: () => const SizedBox(
              height: 80,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => Text(
              context.l10n.unableToLoadMonthlySummary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            data: (summary) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _MonthlyMetric(
                          icon: Icons.arrow_downward_rounded,
                          label: context.l10n.income,
                          amount: summary.income,
                          tone: AppAmountTone.positive,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 54,
                        color: AppTheme.border,
                      ),
                      Expanded(
                        child: _MonthlyMetric(
                          icon: Icons.arrow_upward_rounded,
                          label: context.l10n.expense,
                          amount: summary.expense,
                          tone: AppAmountTone.negative,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: AppTheme.spaceXl,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.netThisMonth,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      AppAmountText(
                        text: _signedRupiah(
                          summary.net,
                        ),
                        tone: summary.net > 0
                            ? AppAmountTone.positive
                            : summary.net < 0
                                ? AppAmountTone.negative
                                : AppAmountTone.normal,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MonthlyMetric extends StatelessWidget {
  const _MonthlyMetric({
    required this.icon,
    required this.label,
    required this.amount,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final int amount;
  final AppAmountTone tone;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      AppAmountTone.positive => AppTheme.success,
      AppAmountTone.negative => AppTheme.danger,
      AppAmountTone.normal => Theme.of(context).colorScheme.primary,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: color,
              ),
              const SizedBox(
                width: AppTheme.spaceXs,
              ),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppTheme.spaceSm,
          ),
          AppAmountText(
            text: _formatRupiah(amount),
            tone: tone,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Accounts
// -----------------------------------------------------------------------------

class _AccountOverview extends StatelessWidget {
  const _AccountOverview({
    required this.accountListAsync,
  });

  final AsyncValue<List<AccountListItem>> accountListAsync;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: accountListAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(
            AppTheme.spaceLg,
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(
            AppTheme.spaceMd,
          ),
          child: Text(
            context.l10n.unableToLoadAccounts,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(
                AppTheme.spaceMd,
              ),
              child: Text(
                context.l10n.noAccountsYet,
              ),
            );
          }

          return Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _AccountBalanceRow(
                  item: items[i],
                ),
                if (i < items.length - 1)
                  const Divider(
                    height: 1,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AccountBalanceRow extends StatelessWidget {
  const _AccountBalanceRow({
    required this.item,
  });

  final AccountListItem item;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMd,
        vertical: 14,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withValues(
                alpha: 0.09,
              ),
              borderRadius: BorderRadius.circular(
                AppTheme.radiusMd,
              ),
            ),
            child: Icon(
              _accountIcon(
                item.account.type,
              ),
              color: primary,
              size: 21,
            ),
          ),
          const SizedBox(
            width: AppTheme.spaceMd,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.account.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  _accountTypeLabel(
                    item.account.type,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: AppTheme.spaceSm,
          ),
          AppAmountText(
            text: _formatRupiah(
              item.currentBalance,
            ),
            tone: item.currentBalance < 0
                ? AppAmountTone.negative
                : AppAmountTone.normal,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Plan
// -----------------------------------------------------------------------------

class _RecurringPlanSummary extends StatelessWidget {
  const _RecurringPlanSummary({
    required this.planAsync,
  });

  final AsyncValue<List<RecurringPlanItem>> planAsync;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: planAsync.when(
        loading: () => const SizedBox(
          height: 80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Text(
          'Unable to load plan.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
        data: (items) {
          final paidCount = items.where(
            (item) {
              return item.isPaid;
            },
          ).length;

          final unpaidCount = items.length - paidCount;

          final progress = items.isEmpty ? 0.0 : paidCount / items.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _monthYearLabel(
                        context,
                        DateTime.now(),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    '$paidCount of ${items.length} paid',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppTheme.spaceMd,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppTheme.radiusSm,
                ),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppTheme.surfaceVariant,
                ),
              ),
              const SizedBox(
                height: AppTheme.spaceMd,
              ),
              Row(
                children: [
                  Expanded(
                    child: _PlanStatus(
                      label: context.l10n.paid,
                      count: paidCount,
                      icon: Icons.check_circle_outline_rounded,
                      color: AppTheme.success,
                    ),
                  ),
                  const SizedBox(
                    width: AppTheme.spaceMd,
                  ),
                  Expanded(
                    child: _PlanStatus(
                      label: context.l10n.unpaid,
                      count: unpaidCount,
                      icon: Icons.schedule_outlined,
                      color: AppTheme.warning,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlanStatus extends StatelessWidget {
  const _PlanStatus({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppTheme.spaceSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(
          AppTheme.radiusMd,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: color,
          ),
          const SizedBox(
            width: AppTheme.spaceSm,
          ),
          Expanded(
            child: Text(
              '$count $label',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Recent Transactions
// -----------------------------------------------------------------------------

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard({
    required this.transactionsAsync,
  });

  final AsyncValue<List<TransactionListItem>> transactionsAsync;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: transactionsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(
            AppTheme.spaceLg,
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(
            AppTheme.spaceMd,
          ),
          child: Text(
            'Unable to load recent transactions.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(
                AppTheme.spaceMd,
              ),
              child: Text(
                context.l10n.noTransactionsYet,
              ),
            );
          }

          final recentItems = items.take(5).toList();

          return Column(
            children: [
              for (var i = 0; i < recentItems.length; i++) ...[
                _RecentTransactionRow(
                  item: recentItems[i],
                ),
                if (i < recentItems.length - 1)
                  const Divider(
                    height: 1,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _RecentTransactionRow extends StatelessWidget {
  const _RecentTransactionRow({
    required this.item,
  });

  final TransactionListItem item;

  @override
  Widget build(BuildContext context) {
    final tone = _transactionTone(
      item,
    );

    final color = switch (tone) {
      AppAmountTone.positive => AppTheme.success,
      AppAmountTone.negative => AppTheme.danger,
      AppAmountTone.normal => Theme.of(context).colorScheme.primary,
    };

    return InkWell(
      onTap: () {
        context.push(
          '/history/transaction',
          extra: item,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: 13,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: 0.09,
                ),
                borderRadius: BorderRadius.circular(
                  AppTheme.radiusMd,
                ),
              ),
              child: Icon(
                _transactionIcon(
                  item.type,
                ),
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(
              width: AppTheme.spaceMd,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: AppTheme.spaceSm,
            ),
            AppAmountText(
              text: _transactionAmount(
                item,
              ),
              tone: tone,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------

AppAmountTone _transactionTone(
  TransactionListItem item,
) {
  return switch (item.type) {
    TransactionType.expense => AppAmountTone.negative,
    TransactionType.income => AppAmountTone.positive,
    TransactionType.transfer => AppAmountTone.normal,
    TransactionType.adjustment => item.amount > 0
        ? AppAmountTone.positive
        : item.amount < 0
            ? AppAmountTone.negative
            : AppAmountTone.normal,
  };
}

IconData _transactionIcon(
  TransactionType type,
) {
  return switch (type) {
    TransactionType.expense => Icons.arrow_upward_rounded,
    TransactionType.income => Icons.arrow_downward_rounded,
    TransactionType.transfer => Icons.swap_horiz_rounded,
    TransactionType.adjustment => Icons.tune_rounded,
  };
}

IconData _accountIcon(
  AccountType type,
) {
  return switch (type) {
    AccountType.bank => Icons.account_balance_outlined,
    AccountType.eWallet => Icons.account_balance_wallet_outlined,
    AccountType.cash => Icons.payments_outlined,
    AccountType.saving => Icons.savings_outlined,
    AccountType.investment => Icons.trending_up_rounded,
  };
}

String _accountTypeLabel(
  AccountType type,
) {
  return switch (type) {
    AccountType.bank => 'Bank',
    AccountType.eWallet => 'E-Wallet',
    AccountType.cash => 'Cash',
    AccountType.saving => 'Saving',
    AccountType.investment => 'Investment',
  };
}

String _transactionAmount(
  TransactionListItem item,
) {
  return switch (item.type) {
    TransactionType.expense => '-${_formatRupiah(item.amount.abs())}',
    TransactionType.income => '+${_formatRupiah(item.amount.abs())}',
    TransactionType.transfer => _formatRupiah(item.amount),
    TransactionType.adjustment => _signedRupiah(item.amount),
  };
}

String _signedRupiah(
  int amount,
) {
  if (amount > 0) {
    return '+${_formatRupiah(amount)}';
  }

  return _formatRupiah(amount);
}

String _monthYearLabel(
  BuildContext context,
  DateTime date,
) {
  return DateFormat.yMMMM(
    Localizations.localeOf(context).languageCode,
  ).format(date);
}

String _greeting(BuildContext context) {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return context.l10n.goodMorning;
  }

  if (hour < 18) {
    return context.l10n.goodAfternoon;
  }

  return context.l10n.goodEvening;
}

String _formatRupiah(
  int amount,
) {
  final isNegative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final positionFromEnd = digits.length - i;

    buffer.write(
      digits[i],
    );

    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${isNegative ? '-' : ''}Rp ${buffer.toString()}';
}
