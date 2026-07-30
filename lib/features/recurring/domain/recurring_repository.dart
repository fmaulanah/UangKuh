import '../../../core/database/app_database.dart';

abstract class RecurringRepository {
  Future<List<RecurringExpense>> getActiveRecurringExpenses(
    String householdId,
  );

  Future<RecurringExpense?> getRecurringExpenseById(String id);

  Future<void> createRecurringExpense({
    required String id,
    required String householdId,
    required String name,
    required int defaultAmount,
    required String categoryId,
    String? defaultAccountId,
    int? dueDay,
    required String userId,
  });

  Future<void> updateRecurringExpense({
    required String id,
    required String name,
    required int defaultAmount,
    required String categoryId,
    String? defaultAccountId,
    int? dueDay,
    required String userId,
  });

  Future<void> deactivateRecurringExpense({
    required String id,
    required String userId,
  });

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
  });

  Future<RecurringPayment?> getRecurringPaymentForPeriod({
    required String recurringExpenseId,
    required int periodYear,
    required int periodMonth,
  });
}
