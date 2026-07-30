import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../auth/providers/app_session_provider.dart';
import 'transaction_repository_provider.dart';

import '../../account/providers/account_list_provider.dart';
import '../../category/providers/category_list_provider.dart';
import '../domain/transaction_type.dart';
import '../presentation/models/transaction_list_item.dart';

final transactionHistoryProvider =
    FutureProvider<List<Transaction>>((ref) async {
  final session = ref.watch(appSessionProvider);

  if (session == null) {
    return [];
  }

  final repository = ref.watch(
    transactionRepositoryProvider,
  );

  return repository.getTransactions(
    session.householdId,
  );
});

final transactionListProvider =
    FutureProvider<List<TransactionListItem>>((ref) async {
  final transactions = await ref.watch(
    transactionHistoryProvider.future,
  );

  final accountItems = await ref.watch(
    accountListProvider.future,
  );

  final categories = await ref.watch(
    categoryListProvider.future,
  );

  final accountNames = {
    for (final item in accountItems) item.account.id: item.account.name,
  };

  final categoryNames = {
    for (final category in categories) category.id: category.name,
  };

  return transactions.map((transaction) {
    return _mapTransaction(
      transaction: transaction,
      accountNames: accountNames,
      categoryNames: categoryNames,
    );
  }).toList();
});

TransactionListItem _mapTransaction({
  required Transaction transaction,
  required Map<String, String> accountNames,
  required Map<String, String> categoryNames,
}) {
  final sourceAccountName = accountNames[transaction.sourceAccountId];

  final destinationAccountName = accountNames[transaction.destinationAccountId];

  final categoryName = categoryNames[transaction.categoryId];

  return switch (transaction.type) {
    TransactionType.expense => TransactionListItem(
        id: transaction.id,
        type: transaction.type,
        title: categoryName ?? 'Expense',
        subtitle: sourceAccountName ?? 'Unknown account',
        amount: transaction.amount,
        transactionDate: transaction.transactionDate,
        expenseType: transaction.expenseType,
        sourceAccountName: sourceAccountName,
        categoryName: categoryName,
        description: transaction.description,
      ),
    TransactionType.income => TransactionListItem(
        id: transaction.id,
        type: transaction.type,
        title: categoryName ?? 'Income',
        subtitle: destinationAccountName ?? 'Unknown account',
        amount: transaction.amount,
        transactionDate: transaction.transactionDate,
        destinationAccountName: destinationAccountName,
        categoryName: categoryName,
        description: transaction.description,
      ),
    TransactionType.transfer => TransactionListItem(
        id: transaction.id,
        type: transaction.type,
        title: 'Transfer',
        subtitle: '${sourceAccountName ?? 'Unknown account'} → '
            '${destinationAccountName ?? 'Unknown account'}',
        amount: transaction.amount,
        transactionDate: transaction.transactionDate,
        sourceAccountName: sourceAccountName,
        destinationAccountName: destinationAccountName,
        description: transaction.description,
      ),
    TransactionType.adjustment => TransactionListItem(
        id: transaction.id,
        type: transaction.type,
        title: 'Adjustment',
        subtitle: destinationAccountName ?? 'Unknown account',
        amount: transaction.amount,
        transactionDate: transaction.transactionDate,
        destinationAccountName: destinationAccountName,
        description: transaction.description,
      ),
  };
}
