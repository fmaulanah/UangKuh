import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/account_purpose.dart';
import '../domain/account_repository.dart';
import '../domain/account_type.dart';

import '../../transaction/domain/transaction_type.dart';

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

  @override
  Future<int> getCurrentBalance(String accountId) async {
    final account = await getAccountById(accountId);

    if (account == null) {
      throw StateError('Account not found.');
    }

    final transactions = await (_database.select(_database.transactions)
          ..where(
            (transaction) =>
                transaction.isDeleted.equals(false) &
                (transaction.sourceAccountId.equals(accountId) |
                    transaction.destinationAccountId.equals(accountId)),
          ))
        .get();

    var balance = account.initialBalance;

    for (final transaction in transactions) {
      switch (transaction.type) {
        case TransactionType.expense:
          if (transaction.sourceAccountId == accountId) {
            balance -= transaction.amount;
          }
          break;

        case TransactionType.income:
          if (transaction.destinationAccountId == accountId) {
            balance += transaction.amount;
          }
          break;

        case TransactionType.transfer:
          if (transaction.sourceAccountId == accountId) {
            balance -= transaction.amount;
          }

          if (transaction.destinationAccountId == accountId) {
            balance += transaction.amount;
          }
          break;

        case TransactionType.adjustment:
          if (transaction.destinationAccountId == accountId) {
            balance += transaction.amount;
          }
          break;
      }
    }

    return balance;
  }

  @override
  Future<int> getTotalBalance(String householdId) async {
    final accounts = await getAccounts(householdId);

    var total = 0;

    for (final account in accounts) {
      total += await getCurrentBalance(account.id);
    }

    return total;
  }
}
