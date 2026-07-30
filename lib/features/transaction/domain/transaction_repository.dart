import '../../../core/database/app_database.dart';
import 'expense_type.dart';

abstract class TransactionRepository {
  Future<Transaction?> getTransactionById(String id);

  Future<List<Transaction>> getTransactions(
    String householdId,
  );

  Future<void> deleteTransaction({
    required String id,
    required String userId,
  });

  Future<void> createExpense({
    required String id,
    required String householdId,
    required String sourceAccountId,
    required String categoryId,
    required int amount,
    required ExpenseType expenseType,
    String? description,
    required DateTime transactionDate,
    required String userId,
  });

  Future<void> createIncome({
    required String id,
    required String householdId,
    required String destinationAccountId,
    required String categoryId,
    required int amount,
    String? description,
    required DateTime transactionDate,
    required String userId,
  });

  Future<void> createTransfer({
    required String id,
    required String householdId,
    required String sourceAccountId,
    required String destinationAccountId,
    required int amount,
    String? description,
    required DateTime transactionDate,
    required String userId,
  });

  Future<void> createAdjustment({
    required String id,
    required String householdId,
    required String accountId,
    required int amount,
    String? description,
    required DateTime transactionDate,
    required String userId,
  });
}
