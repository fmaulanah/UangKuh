import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../recurring/providers/recurring_plan_provider.dart';
import '../../account/providers/account_list_provider.dart';
import '../../auth/providers/app_session_provider.dart';
import '../providers/transaction_history_provider.dart';
import '../providers/transaction_repository_provider.dart';

import '../domain/expense_type.dart';
import '../domain/transaction_type.dart';
import 'models/transaction_list_item.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  const TransactionDetailScreen({
    required this.transaction,
    super.key,
  });

  final TransactionListItem transaction;

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  bool _isDeleting = false;

  TransactionListItem get transaction => widget.transaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: CircleAvatar(
              radius: 28,
              backgroundColor: _containerColor(
                context,
                transaction.type,
              ),
              foregroundColor: _foregroundColor(
                context,
                transaction.type,
              ),
              child: Icon(
                _transactionIcon(transaction.type),
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            transaction.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatTransactionAmount(
              transaction.type,
              transaction.amount,
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _foregroundColor(
                    context,
                    transaction.type,
                  ),
                ),
          ),
          const SizedBox(height: 32),
          _DetailRow(
            label: 'Type',
            value: _transactionTypeLabel(
              transaction.type,
            ),
          ),
          if (transaction.type == TransactionType.expense &&
              transaction.expenseType != null)
            _DetailRow(
              label: 'Expense type',
              value: _expenseTypeLabel(
                transaction.expenseType!,
              ),
            ),
          if (transaction.sourceAccountName != null)
            _DetailRow(
              label: transaction.type == TransactionType.transfer
                  ? 'From'
                  : 'Account',
              value: transaction.sourceAccountName!,
            ),
          if (transaction.destinationAccountName != null)
            _DetailRow(
              label: transaction.type == TransactionType.transfer
                  ? 'To'
                  : 'Account',
              value: transaction.destinationAccountName!,
            ),
          if (transaction.categoryName != null)
            _DetailRow(
              label: 'Category',
              value: transaction.categoryName!,
            ),
          _DetailRow(
            label: 'Date',
            value: _formatDate(
              transaction.transactionDate,
            ),
          ),
          if (transaction.description != null)
            _DetailRow(
              label: 'Description',
              value: transaction.description!,
            ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: _isDeleting ? null : _confirmDelete,
            icon: _isDeleting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.delete_outline),
            label: Text(
              _isDeleting ? 'Deleting...' : 'Delete Transaction',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete transaction?'),
          content: const Text(
            'This transaction will be removed from your history '
            'and its effect on the account balance will be reversed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await _deleteTransaction();
  }

  Future<void> _deleteTransaction() async {
    final session = ref.read(appSessionProvider);

    if (session == null) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      final repository = ref.read(
        transactionRepositoryProvider,
      );

      await repository.deleteTransaction(
        id: transaction.id,
        userId: session.userId,
      );

      ref.invalidate(transactionHistoryProvider);
      ref.invalidate(transactionListProvider);
      ref.invalidate(accountListProvider);
      ref.invalidate(recurringPlanProvider);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isDeleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to delete transaction.',
          ),
        ),
      );
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
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

String _transactionTypeLabel(TransactionType type) {
  return switch (type) {
    TransactionType.expense => 'Expense',
    TransactionType.income => 'Income',
    TransactionType.transfer => 'Transfer',
    TransactionType.adjustment => 'Adjustment',
  };
}

String _expenseTypeLabel(ExpenseType type) {
  return switch (type) {
    ExpenseType.daily => 'Daily',
    ExpenseType.recurring => 'Recurring',
  };
}

IconData _transactionIcon(TransactionType type) {
  return switch (type) {
    TransactionType.expense => Icons.arrow_upward_rounded,
    TransactionType.income => Icons.arrow_downward_rounded,
    TransactionType.transfer => Icons.swap_horiz_rounded,
    TransactionType.adjustment => Icons.tune_rounded,
  };
}

Color _foregroundColor(
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

Color _containerColor(
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

String _formatDate(DateTime date) {
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

  final day = date.day.toString().padLeft(2, '0');

  return '$day ${months[date.month - 1]} ${date.year}';
}
