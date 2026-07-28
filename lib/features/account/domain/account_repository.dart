import '../../../core/database/app_database.dart';

abstract class AccountRepository {
  Future<List<Account>> getAccounts(String householdId);
}
