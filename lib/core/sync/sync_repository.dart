abstract class SyncRepository {
  Future<void> uploadPendingAccounts();

  Future<void> uploadPendingTransactions();
}
