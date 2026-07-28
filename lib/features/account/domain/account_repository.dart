import '../../../core/database/app_database.dart';
import 'account_purpose.dart';
import 'account_type.dart';

abstract class AccountRepository {
  Future<List<Account>> getAccounts(String householdId);

  Future<Account?> getAccountById(String id);

  Future<void> createAccount({
    required String id,
    required String householdId,
    required String name,
    required AccountType type,
    required AccountPurpose purpose,
    required int initialBalance,
    required String userId,
  });

  Future<void> updateAccount({
    required String id,
    required String name,
    required AccountType type,
    required AccountPurpose purpose,
    required String userId,
  });

  Future<void> archiveAccount({
    required String id,
    required String userId,
  });
}
