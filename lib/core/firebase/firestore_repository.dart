import '../../features/category/domain/category_type.dart';

import '../../features/account/domain/account_type.dart';
import '../../features/account/domain/account_purpose.dart';

abstract class FirestoreRepository {
  Future<void> createUser({
    required String uid,
    required String email,
    required String displayName,
  });

  Future<String> createHousehold({
    required String ownerId,
    required String householdName,
  });

  Future<void> createHouseholdMember({
    required String householdId,
    required String userId,
  });

  Future<Map<String, dynamic>?> getHouseholdByInviteCode({
    required String inviteCode,
  });

  Future<void> createMember({
    required String householdId,
    required String userId,
    required String inviteCode,
  });

  Future<void> updateDefaultHousehold({
    required String uid,
    required String householdId,
  });

  Future<Map<String, dynamic>?> getUser({
    required String uid,
  });

  Future<Map<String, dynamic>?> getHousehold({
    required String householdId,
  });

  Future<List<Map<String, dynamic>>> getHouseholdMembers({
    required String householdId,
  });

  Future<void> createCategory({
    required String householdId,
    required String name,
    required CategoryType type,
    required String iconKey,
    required bool isDefault,
    required String createdBy,
  });

  Future<void> upsertCategory({
    required String id,
    required Map<String, dynamic> category,
  });

  Future<List<Map<String, dynamic>>> getCategories({
    required String householdId,
  });

  Future<void> createAccount({
    required String householdId,
    required String name,
    required AccountType type,
    required AccountPurpose purpose,
    required double initialBalance,
    required String iconKey,
    required String color,
    required bool isDefault,
    required String createdBy,
  });

  Future<void> upsertAccount({
    required String id,
    required Map<String, dynamic> account,
  });

  Future<List<Map<String, dynamic>>> getAccounts({
    required String householdId,
  });

  Future<void> upsertRecurringExpense({
    required String id,
    required Map<String, dynamic> recurringExpense,
  });

  Future<void> upsertRecurringPayment({
    required String id,
    required Map<String, dynamic> recurringPayment,
  });

  Future<List<Map<String, dynamic>>> getRecurringExpenses({
    required String householdId,
  });

  Future<List<Map<String, dynamic>>> getRecurringPayments({
    required String householdId,
  });

  Future<void> createTransaction({
    required Map<String, dynamic> transaction,
  });

  Future<List<Map<String, dynamic>>> getTransactions({
    required String householdId,
  });
}

