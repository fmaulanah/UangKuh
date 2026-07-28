import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/account_purpose.dart';
import '../domain/account_repository.dart';
import '../domain/account_type.dart';

class DriftAccountRepository implements AccountRepository {
  DriftAccountRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Account>> getAccounts(String householdId) {
    return (_database.select(_database.accounts)
          ..where(
            (account) =>
                account.householdId.equals(householdId) &
                account.isArchived.equals(false),
          )
          ..orderBy([
            (account) => OrderingTerm.asc(account.name),
          ]))
        .get();
  }

  @override
  Future<Account?> getAccountById(String id) {
    return (_database.select(_database.accounts)
          ..where((account) => account.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<void> createAccount({
    required String id,
    required String householdId,
    required String name,
    required AccountType type,
    required AccountPurpose purpose,
    required int initialBalance,
    required String userId,
  }) async {
    final now = DateTime.now();
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Account name cannot be empty.');
    }

    await _database.into(_database.accounts).insert(
          AccountsCompanion.insert(
            id: id,
            householdId: householdId,
            name: trimmedName,
            type: type,
            purpose: purpose,
            initialBalance: initialBalance,
            createdAt: now,
            updatedAt: now,
            createdBy: userId,
            updatedBy: userId,
          ),
        );
  }

  @override
  Future<void> updateAccount({
    required String id,
    required String name,
    required AccountType type,
    required AccountPurpose purpose,
    required String userId,
  }) async {
    final existingAccount = await getAccountById(id);

    if (existingAccount == null) {
      throw StateError('Account not found.');
    }

    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Account name cannot be empty.');
    }

    await (_database.update(_database.accounts)
          ..where((account) => account.id.equals(id)))
        .write(
      AccountsCompanion(
        name: Value(trimmedName),
        type: Value(type),
        purpose: Value(purpose),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(userId),
      ),
    );
  }

  @override
  Future<void> archiveAccount({
    required String id,
    required String userId,
  }) async {
    final existingAccount = await getAccountById(id);

    if (existingAccount == null) {
      throw StateError('Account not found.');
    }

    await (_database.update(_database.accounts)
          ..where((account) => account.id.equals(id)))
        .write(
      AccountsCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(userId),
      ),
    );
  }
}
