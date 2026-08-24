abstract class SyncRepository {
  Future<void> uploadPendingAccounts();

  Future<void> uploadAccounts();

  Future<void> uploadCategories();

  Future<void> uploadRecurringExpenses();

  Future<void> uploadRecurringPayments();

  Future<void> uploadPendingTransactions();

  Future<void> syncAll();
}



