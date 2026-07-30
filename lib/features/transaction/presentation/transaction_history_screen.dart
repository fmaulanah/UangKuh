import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/widgets/app_surface_card.dart';

import '../providers/transaction_history_provider.dart';
import '../domain/transaction_type.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  TransactionType? _selectedType;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(
      transactionListProvider,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text('Transaction History'),
      ),
      body: transactionsAsync.when(
        loading: () => const _HistoryLoadingState(),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                ),
                const SizedBox(height: 16),
                _HistoryErrorState(
                  onRetry: () {
                    ref.invalidate(
                      transactionHistoryProvider,
                    );
                  },
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(
                      transactionHistoryProvider,
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: const _HistoryEmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No transactions yet',
                message:
                    'Your transaction history will appear here.',
              ),
            );
          }

          final filteredTransactions = transactions.where((transaction) {
            if (_selectedType != null && transaction.type != _selectedType) {
              return false;
            }

            final transactionDate = DateTime(
              transaction.transactionDate.year,
              transaction.transactionDate.month,
              transaction.transactionDate.day,
            );

            if (_startDate != null && transactionDate.isBefore(_startDate!)) {
              return false;
            }

            if (_endDate != null && transactionDate.isAfter(_endDate!)) {
              return false;
            }

            return true;
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HistoryHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMd,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      AppTheme.spaceSm,
                    ),
                    child: _HistoryFilterBar(
                      selectedType: _selectedType,
                      startDate: _startDate,
                      endDate: _endDate,
                      onTypeChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                      onDatePressed: _selectDateRange,
                      onClear: _clearFilters,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: AppTheme.spaceMd,
              ),

              Expanded(
                child: filteredTransactions.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: const _HistoryEmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No matching transactions',
                            message:
                                'Try changing or clearing the filters.',
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        color: AppTheme.primary,
                        onRefresh: () async {
                          ref.invalidate(transactionHistoryProvider);
                          ref.invalidate(transactionListProvider);

                          await ref.read(
                            transactionListProvider.future,
                          );
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            AppTheme.spaceMd,
                            0,
                            AppTheme.spaceMd,
                            AppTheme.spaceLg,
                          ),
                          itemCount: filteredTransactions.length,
                          separatorBuilder: (context, index) {
                            final current = filteredTransactions[index];
                            final next = filteredTransactions[index + 1];

                            if (!_isSameDate(
                              current.transactionDate,
                              next.transactionDate,
                            )) {
                              return const SizedBox.shrink();
                            }

                            return const Divider(
                              height: 1,
                              indent: 60,
                            );
                          },
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];

                            final showDateHeader = index == 0 ||
                                !_isSameDate(
                                  transaction.transactionDate,
                                  filteredTransactions[index - 1]
                                      .transactionDate,
                                );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showDateHeader) ...[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: index == 0
                                          ? AppTheme.spaceSm
                                          : AppTheme.spaceLg,
                                      bottom: AppTheme.spaceSm,
                                    ),
                                    child: Text(
                                      _dateGroupLabel(
                                        transaction.transactionDate,
                                      ).toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1,
                                          ),
                                    ),
                                  ),
                                ],
                                Card(
                                  margin: const EdgeInsets.only(
                                    bottom: AppTheme.spaceSm,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusLg,
                                    ),
                                    onTap: () {
                                      context.push(
                                        '/history/transaction',
                                        extra: transaction,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        AppTheme.spaceMd,
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor:
                                                _transactionContainerColor(
                                              context,
                                              transaction.type,
                                            ),
                                            foregroundColor:
                                                _transactionForegroundColor(
                                              context,
                                              transaction.type,
                                            ),
                                            child: Icon(
                                              _transactionIcon(
                                                transaction.type,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: AppTheme.spaceMd,
                                          ),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  transaction.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),

                                                const SizedBox(
                                                  height: AppTheme.spaceXs,
                                                ),

                                                Text(
                                                  transaction.subtitle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),

                                                if (transaction.description !=
                                                    null) ...[
                                                  const SizedBox(
                                                    height:
                                                        AppTheme.spaceXs,
                                                  ),

                                                  Text(
                                                    transaction.description!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),

                                          const SizedBox(
                                            width: AppTheme.spaceMd,
                                          ),

                                          Text(
                                            _formatTransactionAmount(
                                              transaction.type,
                                              transaction.amount,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color:
                                                      _transactionForegroundColor(
                                                    context,
                                                    transaction.type,
                                                  ),
                                                  fontWeight:
                                                      FontWeight.w700,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _selectDateRange() async {
    final now = DateTime.now();

    final initialStart = _startDate ??
        DateTime(
          now.year,
          now.month,
          1,
        );

    final initialEnd = _endDate ??
        DateTime(
          now.year,
          now.month,
          now.day,
        );

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: initialStart,
        end: initialEnd,
      ),
    );

    if (range == null || !mounted) {
      return;
    }

    setState(() {
      _startDate = DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
      );

      _endDate = DateTime(
        range.end.year,
        range.end.month,
        range.end.day,
      );
    });
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spaceMd,
        AppTheme.spaceMd,
        AppTheme.spaceMd,
        AppTheme.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Transaction History',
          //   style: textTheme.headlineSmall,
          // ),
          // const SizedBox(
          //   height: AppTheme.spaceXs,
          // ),
          // Text(
          //   'Browse and review all your financial activities.',
          //   style: textTheme.bodyMedium?.copyWith(
          //     color: AppTheme.textSecondary,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _HistoryFilterBar extends StatelessWidget {
  const _HistoryFilterBar({
    required this.selectedType,
    required this.startDate,
    required this.endDate,
    required this.onTypeChanged,
    required this.onDatePressed,
    required this.onClear,
  });

  final TransactionType? selectedType;
  final DateTime? startDate;
  final DateTime? endDate;

  final ValueChanged<TransactionType?> onTypeChanged;
  final VoidCallback onDatePressed;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(
        AppTheme.spaceXs,
      ),
      child: Row(
        children: [
          ChoiceChip(
            showCheckmark: false,
            label: const Text('All'),
            selected: selectedType == null,
            onSelected: (_) {
              onTypeChanged(null);
            },
          ),
          const SizedBox(width: 8),
          ...TransactionType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: ChoiceChip(
                showCheckmark: false,
                label: Text(
                  _transactionTypeLabel(type),
                ),
                selected: selectedType == type,
                onSelected: (_) {
                  onTypeChanged(type);
                },
              ),
            ),
          ),
          const SizedBox(width: 4),
          ActionChip(
            backgroundColor: AppTheme.surfaceVariant,
            avatar: const Icon(
              Icons.date_range_outlined,
              size: 18,
            ),
            label: Text(
              _dateRangeLabel(
                startDate,
                endDate,
              ),
            ),
            onPressed: onDatePressed,
          ),
          if (selectedType != null || startDate != null || endDate != null) ...[
            const SizedBox(width: 8),
            ActionChip(
              backgroundColor: AppTheme.surfaceVariant,
              avatar: const Icon(
                Icons.close,
                size: 18,
              ),
              label: const Text('Reset'),
              onPressed: onClear,
            ),
          ],
        ],
      ),
    );
  }
}

class _HistoryErrorState extends StatelessWidget {
  const _HistoryErrorState({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppTheme.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppTheme.danger,
            ),

            const SizedBox(
              height: AppTheme.spaceMd,
            ),

            Text(
              'Unable to load history',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: AppTheme.spaceSm,
            ),

            Text(
              'Please try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),

            const SizedBox(
              height: AppTheme.spaceLg,
            ),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppTheme.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppTheme.textSecondary,
            ),

            const SizedBox(
              height: AppTheme.spaceMd,
            ),

            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: AppTheme.spaceSm,
            ),

            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color:
                        AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryLoadingState extends StatelessWidget {
  const _HistoryLoadingState();

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

String _transactionTypeLabel(TransactionType type) {
  return switch (type) {
    TransactionType.expense => 'Expense',
    TransactionType.income => 'Income',
    TransactionType.transfer => 'Transfer',
    TransactionType.adjustment => 'Adjustment',
  };
}

IconData _transactionIcon(TransactionType type) {
  return switch (type) {
    TransactionType.expense => Icons.arrow_upward_outlined,
    TransactionType.income => Icons.arrow_downward_outlined,
    TransactionType.transfer => Icons.swap_horiz,
    TransactionType.adjustment => Icons.tune,
  };
}

Color _transactionForegroundColor(
  BuildContext context,
  TransactionType type,
) {
  final colors = Theme.of(context).colorScheme;

  return switch (type) {
    TransactionType.expense => colors.error,
    TransactionType.income => colors.primary,
    TransactionType.transfer => colors.tertiary,
    TransactionType.adjustment => colors.secondary,
  };
}

Color _transactionContainerColor(
  BuildContext context,
  TransactionType type,
) {
  final colors = Theme.of(context).colorScheme;

  return switch (type) {
    TransactionType.expense => colors.errorContainer,
    TransactionType.income => colors.primaryContainer,
    TransactionType.transfer => colors.tertiaryContainer,
    TransactionType.adjustment => colors.secondaryContainer,
  };
}

String _formatTransactionAmount(
  TransactionType type,
  int amount,
) {
  final formatted = _formatRupiah(amount.abs());

  return switch (type) {
    TransactionType.expense => '-$formatted',
    TransactionType.income => '+$formatted',
    TransactionType.transfer => formatted,
    TransactionType.adjustment => amount >= 0 ? '+$formatted' : '-$formatted',
  };
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

bool _isSameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _dateGroupLabel(DateTime date) {
  final now = DateTime.now();

  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  final transactionDay = DateTime(
    date.year,
    date.month,
    date.day,
  );

  final difference = today
      .difference(
        transactionDay,
      )
      .inDays;

  if (difference == 0) {
    return 'Today';
  }

  if (difference == 1) {
    return 'Yesterday';
  }

  return _formatGroupDate(date);
}

String _formatGroupDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String _dateRangeLabel(
  DateTime? startDate,
  DateTime? endDate,
) {
  if (startDate == null || endDate == null) {
    return 'All time';
  }

  return '${_shortDate(startDate)} – ${_shortDate(endDate)}';
}

String _shortDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${date.day} ${months[date.month - 1]}';
}
