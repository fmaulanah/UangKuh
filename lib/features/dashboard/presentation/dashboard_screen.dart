import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../transaction/providers/transaction_history_provider.dart';
import '../../transaction/presentation/models/transaction_list_item.dart';
import '../../transaction/domain/transaction_type.dart';

import '../../account/providers/account_list_provider.dart';
import '../../account/presentation/account_list_item.dart';
import '../../account/domain/account_type.dart';

import '../../recurring/providers/recurring_plan_provider.dart';
import '../../recurring/presentation/models/recurring_plan_item.dart';

import '../domain/monthly_summary.dart';
import '../providers/dashboard_total_balance_provider.dart';
import '../providers/dashboard_monthly_summary_provider.dart';

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
      appBar: AppBar(
        title: const Text('Home'),
      ),
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
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              _greeting(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Here\'s your financial overview.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _DashboardBalanceCard(
              totalBalanceAsync: totalBalanceAsync,
            ),
            const SizedBox(height: 24),
            Text(
              'Accounts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _AccountOverview(
              accountListAsync: accountListAsync,
            ),
            const SizedBox(height: 12),
            _MonthlySummaryCard(
              summaryAsync: monthlySummaryAsync,
            ),
            const SizedBox(height: 24),
            Text(
              'Plan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _RecurringPlanSummary(
              planAsync: recurringPlanAsync,
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.remove,
                    label: 'Expense',
                    onPressed: () {
                      context.push('/expense/new');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.add,
                    label: 'Income',
                    onPressed: () {
                      context.push('/income/new');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.swap_horiz,
                    label: 'Transfer',
                    onPressed: () {
                      context.push('/transfer/new');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _RecentTransactionsCard(
              transactionsAsync: recentTransactionsAsync,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.go('/history');
                },
                child: const Text('View all'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBalanceCard extends StatelessWidget {
  const _DashboardBalanceCard({
    required this.totalBalanceAsync,
  });

  final AsyncValue<int> totalBalanceAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                ),
                const SizedBox(width: 8),
                Text(
                  'Total Balance',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            totalBalanceAsync.when(
              loading: () => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              error: (error, stackTrace) => Text(
                'Unable to load balance.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              data: (balance) => Text(
                _formatRupiah(balance),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AccountOverview extends StatelessWidget {
  const _AccountOverview({
    required this.accountListAsync,
  });

  final AsyncValue<List<AccountListItem>> accountListAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: accountListAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Unable to load accounts.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No accounts yet.',
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(
              _accountIcon(item.account.type),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.account.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatRupiah(
              item.currentBalance,
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard({
    required this.summaryAsync,
  });

  final AsyncValue<MonthlySummary> summaryAsync;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Month',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        _monthYearLabel(now),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            summaryAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Text(
                'Unable to load monthly summary.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              data: (summary) {
                return Column(
                  children: [
                    _SummaryRow(
                      label: 'Income',
                      amount: summary.income,
                    ),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: 'Expense',
                      amount: summary.expense,
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Net',
                      amount: summary.net,
                      emphasized: true,
                      showSign: true,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    this.emphasized = false,
    this.showSign = false,
  });

  final String label;
  final int amount;
  final bool emphasized;
  final bool showSign;

  @override
  Widget build(BuildContext context) {
    final amountText = showSign && amount > 0
        ? '+${_formatRupiah(amount)}'
        : _formatRupiah(amount);

    final style = emphasized
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            )
        : Theme.of(context).textTheme.bodyLarge;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: style,
          ),
        ),
        Text(
          amountText,
          style: style,
        ),
      ],
    );
  }
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard({
    required this.transactionsAsync,
  });

  final AsyncValue<List<TransactionListItem>> transactionsAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: transactionsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Unable to load recent transactions.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No transactions yet.',
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
    return InkWell(
      onTap: () {
        context.push(
          '/history/${item.id}',
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(
                _transactionIcon(item.type),
              ),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _transactionAmount(item),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecurringPlanSummary extends StatelessWidget {
  const _RecurringPlanSummary({
    required this.planAsync,
  });

  final AsyncValue<List<RecurringPlanItem>> planAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: planAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Text(
            'Unable to load plan.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
          data: (items) {
            final paidCount = items
                .where(
                  (item) => item.isPaid,
                )
                .length;

            final unpaidCount = items.length - paidCount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _monthYearLabel(
                    DateTime.now(),
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _PlanStatus(
                        label: 'Paid',
                        count: paidCount,
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PlanStatus(
                        label: 'Unpaid',
                        count: unpaidCount,
                        icon: Icons.schedule_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${items.length} recurring '
                  '${items.length == 1 ? 'expense' : 'expenses'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlanStatus extends StatelessWidget {
  const _PlanStatus({
    required this.label,
    required this.count,
    required this.icon,
  });

  final String label;
  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '$count $label',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
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

IconData _accountIcon(AccountType type) {
  return switch (type) {
    AccountType.bank => Icons.account_balance_outlined,
    AccountType.eWallet => Icons.account_balance_wallet_outlined,
    AccountType.cash => Icons.payments_outlined,
    AccountType.saving => Icons.savings_outlined,
    AccountType.investment => Icons.trending_up,
  };
}

String _transactionAmount(
  TransactionListItem item,
) {
  return switch (item.type) {
    TransactionType.expense => '-${_formatRupiah(item.amount)}',
    TransactionType.income => '+${_formatRupiah(item.amount)}',
    TransactionType.transfer => _formatRupiah(item.amount),
    TransactionType.adjustment => _formatRupiah(item.amount),
  };
}

String _monthYearLabel(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return '${months[date.month - 1]} ${date.year}';
}

String _greeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good morning';
  }

  if (hour < 18) {
    return 'Good afternoon';
  }

  return 'Good evening';
}

String _formatRupiah(int amount) {
  final isNegative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final positionFromEnd = digits.length - i;

    buffer.write(digits[i]);

    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${isNegative ? '-' : ''}Rp ${buffer.toString()}';
}
