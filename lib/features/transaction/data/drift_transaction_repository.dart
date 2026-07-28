import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../category/domain/category_type.dart';
import '../domain/expense_type.dart';
import '../domain/sync_status.dart';
import '../domain/transaction_repository.dart';
import '../domain/transaction_type.dart';

class DriftTransactionRepository implements TransactionRepository {
  DriftTransactionRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Transaction?> getTransactionById(String id) {
    return (_database.select(_database.transactions)
          ..where((transaction) => transaction.id.equals(id)))
        .getSingleOrNull();
  }

  @override
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
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Expense amount must be greater than zero.');
    }

    final account = await _getAccount(sourceAccountId);

    if (account.householdId != householdId) {
      throw StateError('Account does not belong to this household.');
    }

    if (account.isArchived) {
      throw StateError('Archived account cannot be used.');
    }

    final category = await _getCategory(categoryId);

    if (category.householdId != householdId) {
      throw StateError('Category does not belong to this household.');
    }

    if (category.isArchived) {
      throw StateError('Archived category cannot be used.');
    }

    if (category.type != CategoryType.expense) {
      throw StateError('Expense requires an expense category.');
    }

    final now = DateTime.now();
    final cleanDescription = _cleanDescription(description);

    await _database.into(_database.transactions).insert(
          TransactionsCompanion.insert(
            id: id,
            householdId: householdId,
            type: TransactionType.expense,
            expenseType: Value(expenseType),
            amount: amount,
            sourceAccountId: Value(sourceAccountId),
            categoryId: Value(categoryId),
            description: Value(cleanDescription),
            transactionDate: transactionDate,
            createdBy: userId,
            updatedBy: userId,
            createdAt: now,
            updatedAt: now,
            syncStatus: SyncStatus.pending,
          ),
        );
  }

  @override
  Future<void> createIncome({
    required String id,
    required String householdId,
    required String destinationAccountId,
    required String categoryId,
    required int amount,
    String? description,
    required DateTime transactionDate,
    required String userId,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Income amount must be greater than zero.');
    }

    final account = await _getAccount(destinationAccountId);

    if (account.householdId != householdId) {
      throw StateError('Account does not belong to this household.');
    }

    if (account.isArchived) {
      throw StateError('Archived account cannot be used.');
    }

    final category = await _getCategory(categoryId);

    if (category.householdId != householdId) {
      throw StateError('Category does not belong to this household.');
    }

    if (category.isArchived) {
      throw StateError('Archived category cannot be used.');
    }

    if (category.type != CategoryType.income) {
      throw StateError('Income requires an income category.');
    }

    final now = DateTime.now();
    final cleanDescription = _cleanDescription(description);

    await _database.into(_database.transactions).insert(
          TransactionsCompanion.insert(
            id: id,
            householdId: householdId,
            type: TransactionType.income,
            amount: amount,
            destinationAccountId: Value(destinationAccountId),
            categoryId: Value(categoryId),
            description: Value(cleanDescription),
            transactionDate: transactionDate,
            createdBy: userId,
            updatedBy: userId,
            createdAt: now,
            updatedAt: now,
            syncStatus: SyncStatus.pending,
          ),
        );
  }

  @override
  Future<void> createTransfer({
    required String id,
    required String householdId,
    required String sourceAccountId,
    required String destinationAccountId,
    required int amount,
    String? description,
    required DateTime transactionDate,
    required String userId,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Transfer amount must be greater than zero.');
    }

    if (sourceAccountId == destinationAccountId) {
      throw ArgumentError(
        'Source and destination accounts must be different.',
      );
    }

    final sourceAccount = await _getAccount(sourceAccountId);
    final destinationAccount = await _getAccount(destinationAccountId);

    if (sourceAccount.householdId != householdId) {
      throw StateError(
        'Source account does not belong to this household.',
      );
    }

    if (destinationAccount.householdId != householdId) {
      throw StateError(
        'Destination account does not belong to this household.',
      );
    }

    if (sourceAccount.isArchived) {
      throw StateError('Archived source account cannot be used.');
    }

    if (destinationAccount.isArchived) {
      throw StateError('Archived destination account cannot be used.');
    }

    final now = DateTime.now();
    final cleanDescription = _cleanDescription(description);

    await _database.into(_database.transactions).insert(
          TransactionsCompanion.insert(
            id: id,
            householdId: householdId,
            type: TransactionType.transfer,
            amount: amount,
            sourceAccountId: Value(sourceAccountId),
            destinationAccountId: Value(destinationAccountId),
            description: Value(cleanDescription),
            transactionDate: transactionDate,
            createdBy: userId,
            updatedBy: userId,
            createdAt: now,
            updatedAt: now,
            syncStatus: SyncStatus.pending,
          ),
        );
  }

  @override
  Future<void> createAdjustment({
    required String id,
    required String householdId,
    required String accountId,
    required int amount,
    String? description,
    required DateTime transactionDate,
    required String userId,
  }) async {
    if (amount == 0) {
      throw ArgumentError('Adjustment amount cannot be zero.');
    }

    final account = await _getAccount(accountId);

    if (account.householdId != householdId) {
      throw StateError(
        'Account does not belong to this household.',
      );
    }

    if (account.isArchived) {
      throw StateError('Archived account cannot be used.');
    }

    final now = DateTime.now();
    final cleanDescription = _cleanDescription(description);

    await _database.into(_database.transactions).insert(
          TransactionsCompanion.insert(
            id: id,
            householdId: householdId,
            type: TransactionType.adjustment,
            amount: amount,
            destinationAccountId: Value(accountId),
            description: Value(cleanDescription),
            transactionDate: transactionDate,
            createdBy: userId,
            updatedBy: userId,
            createdAt: now,
            updatedAt: now,
            syncStatus: SyncStatus.pending,
          ),
        );
  }

  Future<Account> _getAccount(String id) async {
    final account = await (_database.select(_database.accounts)
          ..where((account) => account.id.equals(id)))
        .getSingleOrNull();

    if (account == null) {
      throw StateError('Account not found.');
    }

    return account;
  }

  Future<Category> _getCategory(String id) async {
    final category = await (_database.select(_database.categories)
          ..where((category) => category.id.equals(id)))
        .getSingleOrNull();

    if (category == null) {
      throw StateError('Category not found.');
    }

    return category;
  }

  String? _cleanDescription(String? description) {
    final value = description?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }
}
