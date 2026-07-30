import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';

import '../providers/recurring_list_provider.dart';
import '../providers/recurring_plan_provider.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(
      recurringPlanProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan'),
        actions: [
          IconButton(
            tooltip: 'Add recurring expense',
            onPressed: () {
              context.push('/plan/new');
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: planAsync.when(
        loading: () => const _RecurringLoadingState(),
        error: (error, stackTrace) => _RecurringError(
          onRetry: () {
            ref.invalidate(recurringListProvider);
          },
        ),
        data: (planItems) {
          if (planItems.isEmpty) {
            return const _RecurringEmptyState();
          }

          final totalAmount = planItems.fold<int>(
            0,
            (sum, item) => sum + item.recurringExpense.defaultAmount,
          );

          final paidCount = planItems
              .where(
                (e) => e.isPaid,
              )
              .length;

          final unpaidCount = planItems.length - paidCount;

          final now = DateTime.now();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _RecurringHeader(),
              const SizedBox(
                height: AppTheme.spaceMd,
              ),
              _RecurringSummaryCard(
                month: _monthYearLabel(now),
                totalAmount: totalAmount,
                paidCount: paidCount,
                unpaidCount: unpaidCount,
              ),
              const SizedBox(
                height: AppTheme.spaceMd,
              ),
              const SizedBox(
                height: AppTheme.spaceMd,
              ),
              Expanded(
                child: RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: () async {
                    ref.invalidate(recurringListProvider);
                    ref.invalidate(recurringPlanProvider);

                    await ref.read(
                      recurringPlanProvider.future,
                    );
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spaceMd,
                      AppTheme.spaceMd,
                      AppTheme.spaceMd,
                      AppTheme.spaceLg,
                    ),
                    itemCount: planItems.length,
                    itemBuilder: (context, index) {
                      final item = planItems[index];
                      final recurring = item.recurringExpense;

                      return _RecurringCard(
                        item: item,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecurringError extends StatelessWidget {
  const _RecurringError({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load recurring expenses.',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentStatusBadge extends StatelessWidget {
  const _PaymentStatusBadge({
    required this.isPaid,
  });

  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor =
        isPaid ? colorScheme.primaryContainer : colorScheme.errorContainer;

    final foregroundColor =
        isPaid ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isPaid ? 'Paid' : 'Unpaid',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _RecurringCard extends StatelessWidget {
  const _RecurringCard({
    required this.item,
  });

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    final recurring = item.recurringExpense;

    return Card(
      margin: const EdgeInsets.only(
        bottom: AppTheme.spaceMd,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppTheme.radiusLg,
        ),
        onTap: () {
          context.push(
            '/plan/${recurring.id}/edit',
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(
            AppTheme.spaceMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(
                      Icons.autorenew_rounded,
                    ),
                  ),
                  const SizedBox(
                    width: AppTheme.spaceMd,
                  ),
                  Expanded(
                    child: Text(
                      recurring.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppTheme.spaceMd,
              ),
              Text(
                recurring.dueDay == null
                    ? 'No due date'
                    : 'Due day ${recurring.dueDay}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
              const SizedBox(
                height: AppTheme.spaceXs,
              ),
              Text(
                _formatRupiah(
                  recurring.defaultAmount,
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: AppTheme.spaceMd,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: item.isPaid
                    ? const _PaymentStatusBadge(
                        isPaid: true,
                      )
                    : FilledButton(
                        onPressed: () {
                          context.push(
                            '/plan/${recurring.id}/pay',
                          );
                        },
                        child: const Text(
                          'Pay',
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _RecurringHeader extends StatelessWidget {
  const _RecurringHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppTheme.spaceMd,
        AppTheme.spaceMd,
        AppTheme.spaceMd,
        0,
      ),
      child: _RecurringHeaderContent(),
    );
  }
}

class _RecurringHeaderContent extends StatelessWidget {
  const _RecurringHeaderContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recurring Plan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppTheme.spaceXs),
        Text(
          'Manage your monthly recurring expenses.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _RecurringEmptyState extends StatelessWidget {
  const _RecurringEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        AppTheme.spaceLg,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.autorenew_rounded,
              size: 56,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(
              height: AppTheme.spaceMd,
            ),
            Text(
              'No recurring plans yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: AppTheme.spaceXs,
            ),
            Text(
              'Create recurring expenses for bills,\nsubscriptions, or monthly payments.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecurringLoadingState extends StatelessWidget {
  const _RecurringLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(
          AppTheme.spaceLg,
        ),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _RecurringSummaryCard extends StatelessWidget {
  const _RecurringSummaryCard({
    required this.month,
    required this.totalAmount,
    required this.paidCount,
    required this.unpaidCount,
  });

  final String month;
  final int totalAmount;
  final int paidCount;
  final int unpaidCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(
          AppTheme.spaceMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              month,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: AppTheme.spaceMd,
            ),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    title: 'Total Plan',
                    value: _formatRupiah(totalAmount),
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    title: 'Paid',
                    value: '$paidCount',
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    title: 'Remaining',
                    value: '$unpaidCount',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: AppTheme.spaceXs,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

String _formatRupiah(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final positionFromEnd = digits.length - i;

    buffer.write(digits[i]);

    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'Rp ${buffer.toString()}';
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
