import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        title: const Text('History'),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
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
                const Text(
                  'Unable to load transactions.',
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
              child: Text(
                'No transactions yet.',
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
            children: [
              _HistoryFilterBar(
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
              Expanded(
                child: filteredTransactions.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'No transactions match these filters.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(transactionHistoryProvider);
                          ref.invalidate(transactionListProvider);

                          await ref.read(
                            transactionListProvider.future,
                          );
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
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
                                      left: 4,
                                      right: 4,
                                      top: index == 0 ? 4 : 20,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      _dateGroupLabel(
                                        transaction.transactionDate,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ],
                                ListTile(
                                  onTap: () {
                                    context.push(
                                      '/history/transaction',
                                      extra: transaction,
                                    );
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 6,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: _transactionContainerColor(
                                      context,
                                      transaction.type,
                                    ),
                                    foregroundColor:
                                        _transactionForegroundColor(
                                      context,
                                      transaction.type,
                                    ),
                                    child: Icon(
                                      _transactionIcon(transaction.type),
                                    ),
                                  ),
                                  title: Text(
                                    transaction.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaction.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (transaction.description != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          transaction.description!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: Text(
                                    _formatTransactionAmount(
                                      transaction.type,
                                      transaction.amount,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: _transactionForegroundColor(
                                            context,
                                            transaction.type,
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
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        4,
      ),
      child: Row(
        children: [
          ChoiceChip(
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
