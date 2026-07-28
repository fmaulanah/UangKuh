import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../category/domain/category_type.dart';
import '../../transaction/domain/expense_type.dart';
import '../../transaction/domain/sync_status.dart';
import '../../transaction/domain/transaction_type.dart';
import '../domain/recurring_payment_status.dart';
import '../domain/recurring_repository.dart';

class DriftRecurringRepository implements RecurringRepository {
  DriftRecurringRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<RecurringExpense>> getActiveRecurringExpenses(
    String householdId,
  ) {
    return (_database.select(_database.recurringExpenses)
          ..where(
            (item) =>
                item.householdId.equals(householdId) &
                item.isActive.equals(true),
          )
          ..orderBy([
            (item) => OrderingTerm.asc(item.dueDay),
            (item) => OrderingTerm.asc(item.name),
          ]))
        .get();
  }

  @override
  Future<RecurringExpense?> getRecurringExpenseById(String id) {
    return (_database.select(_database.recurringExpenses)
          ..where((item) => item.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<void> createRecurringExpense({
    required String id,
    required String householdId,
    required String name,
    required int defaultAmount,
    required String categoryId,
    String? defaultAccountId,
    int? dueDay,
    required String userId,
  }) async {
    final cleanName = name.trim();

    if (cleanName.isEmpty) {
      throw ArgumentError('Recurring expense name cannot be empty.');
    }

    if (defaultAmount <= 0) {
      throw ArgumentError(
        'Default amount must be greater than zero.',
      );
    }

    if (dueDay != null && (dueDay < 1 || dueDay > 31)) {
      throw ArgumentError('Due day must be between 1 and 31.');
    }

    final category = await _getCategory(categoryId);

    if (category.householdId != householdId) {
      throw StateError(
        'Category does not belong to this household.',
      );
    }

    if (category.isArchived) {
      throw StateError('Archived category cannot be used.');
    }

    if (category.type != CategoryType.expense) {
      throw StateError(
        'Recurring expense requires an expense category.',
      );
    }

    if (defaultAccountId != null) {
      final account = await _getAccount(defaultAccountId);

      if (account.householdId != householdId) {
        throw StateError(
          'Account does not belong to this household.',
        );
      }

      if (account.isArchived) {
        throw StateError('Archived account cannot be used.');
      }
    }

    final now = DateTime.now();

    await _database.into(_database.recurringExpenses).insert(
          RecurringExpensesCompanion.insert(
            id: id,
            householdId: householdId,
            name: cleanName,
            defaultAmount: defaultAmount,
            categoryId: categoryId,
            defaultAccountId: Value(defaultAccountId),
            dueDay: Value(dueDay),
            createdAt: now,
            updatedAt: now,
            createdBy: userId,
            updatedBy: userId,
          ),
        );
  }

  @override
  Future<void> deactivateRecurringExpense({
    required String id,
    required String userId,
  }) async {
    final recurring = await getRecurringExpenseById(id);

    if (recurring == null) {
      throw StateError('Recurring expense not found.');
    }

    await (_database.update(_database.recurringExpenses)
          ..where((item) => item.id.equals(id)))
        .write(
      RecurringExpensesCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(userId),
      ),
    );
  }

  @override
  Future<void> payRecurringExpense({
    required String paymentId,
    required String transactionId,
    required String recurringExpenseId,
    required String householdId,
    required int periodYear,
    required int periodMonth,
    required int amount,
    required String sourceAccountId,
    String? description,
    required DateTime transactionDate,
    required String userId,
  }) async {
    if (periodMonth < 1 || periodMonth > 12) {
      throw ArgumentError('Period month must be between 1 and 12.');
    }

    if (periodYear <= 0) {
      throw ArgumentError('Period year must be valid.');
    }

    if (amount <= 0) {
      throw ArgumentError(
        'Recurring payment amount must be greater than zero.',
      );
    }

    final recurring = await getRecurringExpenseById(
      recurringExpenseId,
    );

    if (recurring == null) {
      throw StateError('Recurring expense not found.');
    }

    if (recurring.householdId != householdId) {
      throw StateError(
        'Recurring expense does not belong to this household.',
      );
    }

    if (!recurring.isActive) {
      throw StateError(
        'Inactive recurring expense cannot be paid.',
      );
    }

    final account = await _getAccount(sourceAccountId);

    if (account.householdId != householdId) {
      throw StateError(
        'Account does not belong to this household.',
      );
    }

    if (account.isArchived) {
      throw StateError('Archived account cannot be used.');
    }

    final category = await _getCategory(recurring.categoryId);

    if (category.householdId != householdId) {
      throw StateError(
        'Category does not belong to this household.',
      );
    }

    if (category.isArchived) {
      throw StateError('Archived category cannot be used.');
    }

    if (category.type != CategoryType.expense) {
      throw StateError(
        'Recurring expense requires an expense category.',
      );
    }

    final existingPayment = await (_database.select(_database.recurringPayments)
          ..where(
            (payment) =>
                payment.recurringExpenseId.equals(
                  recurringExpenseId,
                ) &
                payment.periodYear.equals(periodYear) &
                payment.periodMonth.equals(periodMonth),
          ))
        .getSingleOrNull();

    if (existingPayment != null) {
      throw StateError(
        'Recurring expense has already been paid for this period.',
      );
    }

    final now = DateTime.now();
    final cleanDescription = _cleanDescription(description);

    await _database.transaction(() async {
      await _database.into(_database.transactions).insert(
            TransactionsCompanion.insert(
              id: transactionId,
              householdId: householdId,
              type: TransactionType.expense,
              expenseType: const Value(ExpenseType.recurring),
              amount: amount,
              sourceAccountId: Value(sourceAccountId),
              categoryId: Value(recurring.categoryId),
              description: Value(cleanDescription),
              transactionDate: transactionDate,
              createdBy: userId,
              updatedBy: userId,
              createdAt: now,
              updatedAt: now,
              syncStatus: SyncStatus.pending,
            ),
          );

      await _database.into(_database.recurringPayments).insert(
            RecurringPaymentsCompanion.insert(
              id: paymentId,
              householdId: householdId,
              recurringExpenseId: recurringExpenseId,
              periodYear: periodYear,
              periodMonth: periodMonth,
              status: RecurringPaymentStatus.paid,
              transactionId: Value(transactionId),
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );
    });
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
