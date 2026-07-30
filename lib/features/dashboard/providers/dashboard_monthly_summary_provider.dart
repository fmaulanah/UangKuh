import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../transaction/domain/transaction_type.dart';
import '../../transaction/providers/transaction_history_provider.dart';
import '../domain/monthly_summary.dart';

final dashboardMonthlySummaryProvider =
    FutureProvider<MonthlySummary>((ref) async {
  final transactions = await ref.watch(
    transactionHistoryProvider.future,
  );

  final now = DateTime.now();

  var income = 0;
  var expense = 0;

  for (final transaction in transactions) {
    final date = transaction.transactionDate;

    final isCurrentMonth = date.year == now.year && date.month == now.month;

    if (!isCurrentMonth) {
      continue;
    }

    switch (transaction.type) {
      case TransactionType.income:
        income += transaction.amount;

      case TransactionType.expense:
        expense += transaction.amount;

      case TransactionType.transfer:
      case TransactionType.adjustment:
        break;
    }
  }

  return MonthlySummary(
    income: income,
    expense: expense,
  );
});
