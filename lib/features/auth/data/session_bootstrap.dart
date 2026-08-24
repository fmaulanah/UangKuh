import 'package:drift/drift.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/database/app_database.dart';
import '../../../core/firebase/firestore_repository.dart';
import '../domain/app_session.dart';

import '../../household/domain/household_role.dart';
import '../../category/domain/category_type.dart';
import '../../account/domain/account_type.dart';
import '../../account/domain/account_purpose.dart';
import '../../transaction/domain/expense_type.dart';
import '../../transaction/domain/sync_status.dart';
import '../../transaction/domain/transaction_type.dart';

class SessionBootstrap {
  SessionBootstrap(
    this._database,
    this._firestoreRepository,
  );

  final AppDatabase _database;
  final FirestoreRepository _firestoreRepository;

  Future<AppSession> bootstrap({
    required String userId,
    required String email,
    required String displayName,
  }) async {
    final cloudUser = await _firestoreRepository.getUser(
      uid: userId,
    );

    if (cloudUser == null) {
      throw Exception('User document not found.');
    }

    final cloudHousehold = await _firestoreRepository.getHousehold(
      householdId: cloudUser['defaultHouseholdId'] as String,
    );

    if (cloudHousehold == null) {
      throw Exception('Household document not found.');
    }

    final user = await _resolveLocalUser(
      userId: cloudUser['uid'] as String,
      email: cloudUser['email'] as String,
      displayName: cloudUser['displayName'] as String,
    );

    final household = await _resolveLocalHousehold(
      householdId: cloudHousehold['id'] as String,
      householdName: cloudHousehold['name'] as String,
      inviteCode: cloudHousehold['inviteCode'] as String,
      createdBy: cloudHousehold['createdBy'] as String,
    );

    final cloudMembers = await _firestoreRepository.getHouseholdMembers(
      householdId: household.id,
    );

    for (final member in cloudMembers) {
      await _resolveLocalMembership(
        memberId: member['id'] as String,
        householdId: member['householdId'] as String,
        userId: member['userId'] as String,
        role: HouseholdRole.values.byName(
          member['role'] as String,
        ),
        joinedAt: (member['joinedAt'] as Timestamp).toDate(),
      );
    }

    final cloudCategories = await _firestoreRepository.getCategories(
      householdId: household.id,
    );

    await _syncCategories(
      cloudCategories: cloudCategories,
    );

    final cloudAccounts = await _firestoreRepository.getAccounts(
      householdId: household.id,
    );

    await _syncAccounts(
      cloudAccounts: cloudAccounts,
    );

    final cloudTransactions = await _firestoreRepository.getTransactions(
      householdId: household.id,
    );

    await _syncTransactions(
      cloudTransactions: cloudTransactions,
    );

    return AppSession(
      userId: user.id,
      householdId: household.id,
      email: user.email,
      displayName: user.displayName,
    );
  }

  Future<User> _resolveLocalUser({
    required String userId,
    required String email,
    required String displayName,
  }) async {
    final existingUser = await (_database.select(_database.users)
          ..where((user) => user.id.equals(userId)))
        .getSingleOrNull();

    final now = DateTime.now();

    if (existingUser == null) {
      await _database.into(_database.users).insert(
            UsersCompanion.insert(
              id: userId,
              email: email,
              displayName: displayName,
              createdAt: now,
              updatedAt: now,
            ),
          );
    } else {
      await (_database.update(_database.users)
            ..where((user) => user.id.equals(userId)))
          .write(
        UsersCompanion(
          email: Value(email),
          displayName: Value(displayName),
          updatedAt: Value(now),
        ),
      );
    }

    return (_database.select(_database.users)
          ..where((user) => user.id.equals(userId)))
        .getSingle();
  }

  Future<Household> _resolveLocalHousehold({
    required String householdId,
    required String householdName,
    required String inviteCode,
    required String createdBy,
  }) async {
    final existingHousehold = await (_database.select(_database.households)
          ..where(
            (household) => household.id.equals(householdId),
          ))
        .getSingleOrNull();

    Household household;

    if (existingHousehold != null) {
      household = existingHousehold;
    } else {
      final now = DateTime.now();

      await _database.into(_database.households).insert(
            HouseholdsCompanion.insert(
              id: householdId,
              name: householdName,
              inviteCode: inviteCode,
              createdBy: createdBy,
              createdAt: now,
              updatedAt: now,
            ),
          );

      household = await (_database.select(_database.households)
            ..where(
              (household) => household.id.equals(householdId),
            ))
          .getSingle();
    }

    return household;
  }

  Future<void> _resolveLocalMembership({
    required String memberId,
    required String householdId,
    required String userId,
    required HouseholdRole role,
    required DateTime joinedAt,
  }) async {
    final existingMembership =
        await (_database.select(_database.householdMembers)
              ..where(
                (member) => member.id.equals(memberId),
              ))
            .getSingleOrNull();

    if (existingMembership == null) {
      await _database.into(_database.householdMembers).insert(
            HouseholdMembersCompanion.insert(
              id: memberId,
              householdId: householdId,
              userId: userId,
              role: role,
              joinedAt: joinedAt,
            ),
          );
    } else {
      await (_database.update(_database.householdMembers)
            ..where(
              (member) => member.id.equals(memberId),
            ))
          .write(
        HouseholdMembersCompanion(
          householdId: Value(householdId),
          userId: Value(userId),
          role: Value(role),
          joinedAt: Value(joinedAt),
        ),
      );
    }
  }

  Future<void> _syncCategories({
    required List<Map<String, dynamic>> cloudCategories,
  }) async {
    for (final category in cloudCategories) {
      await _resolveLocalCategory(
        id: category['id'] as String,
        householdId: category['householdId'] as String,
        name: category['name'] as String,
        type: CategoryType.values.byName(
          category['type'] as String,
        ),
        iconKey: category['iconKey'] as String,
        isDefault: category['isDefault'] as bool,
        isArchived: category['isArchived'] as bool,
        createdBy: category['createdBy'] as String,
        updatedBy: category['updatedBy'] as String,
        createdAt: (category['createdAt'] as Timestamp).toDate(),
        updatedAt: (category['updatedAt'] as Timestamp).toDate(),
      );
    }
  }

  Future<void> _resolveLocalCategory({
    required String id,
    required String householdId,
    required String name,
    required CategoryType type,
    required String iconKey,
    required bool isDefault,
    required bool isArchived,
    required String createdBy,
    required String updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) async {
    final existingCategory = await (_database.select(_database.categories)
          ..where((category) => category.id.equals(id)))
        .getSingleOrNull();

    if (existingCategory == null) {
      await _database.into(_database.categories).insert(
            CategoriesCompanion.insert(
              id: id,
              householdId: householdId,
              name: name,
              type: type,
              iconKey: iconKey,
              isDefault: Value(isDefault),
              isArchived: Value(isArchived),
              createdAt: createdAt,
              updatedAt: updatedAt,
              createdBy: createdBy,
              updatedBy: updatedBy,
            ),
          );
    } else {
      await (_database.update(_database.categories)
            ..where((category) => category.id.equals(id)))
          .write(
        CategoriesCompanion(
          householdId: Value(householdId),
          name: Value(name),
          type: Value(type),
          iconKey: Value(iconKey),
          isDefault: Value(isDefault),
          isArchived: Value(isArchived),
          createdAt: Value(createdAt),
          updatedAt: Value(updatedAt),
          createdBy: Value(createdBy),
          updatedBy: Value(updatedBy),
        ),
      );
    }
  }

  Future<void> _syncAccounts({
    required List<Map<String, dynamic>> cloudAccounts,
  }) async {
    for (final account in cloudAccounts) {
      await _resolveLocalAccount(
        id: account['id'] as String,
        householdId: account['householdId'] as String,
        name: account['name'] as String,
        type: AccountType.values.byName(
          account['type'] as String,
        ),
        purpose: AccountPurpose.values.byName(
          account['purpose'] as String,
        ),
        initialBalance: (account['initialBalance'] as num).toInt(),
        isArchived: account['isArchived'] as bool,
        createdAt: (account['createdAt'] as Timestamp).toDate(),
        updatedAt: (account['updatedAt'] as Timestamp).toDate(),
        createdBy: account['createdBy'] as String,
        updatedBy: account['updatedBy'] as String,
      );
    }
  }

  Future<void> _resolveLocalAccount({
    required String id,
    required String householdId,
    required String name,
    required AccountType type,
    required AccountPurpose purpose,
    required int initialBalance,
    required bool isArchived,
    required String createdBy,
    required String updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) async {
    final existingAccount = await (_database.select(_database.accounts)
          ..where((account) => account.id.equals(id)))
        .getSingleOrNull();

    if (existingAccount == null) {
      await _database.into(_database.accounts).insert(
            AccountsCompanion.insert(
              id: id,
              householdId: householdId,
              name: name,
              type: type,
              purpose: purpose,
              initialBalance: initialBalance,
              isArchived: Value(isArchived),
              createdAt: createdAt,
              updatedAt: updatedAt,
              createdBy: createdBy,
              updatedBy: updatedBy,
            ),
          );
    } else {
      await (_database.update(_database.accounts)
            ..where((account) => account.id.equals(id)))
          .write(
        AccountsCompanion(
          householdId: Value(householdId),
          name: Value(name),
          type: Value(type),
          purpose: Value(purpose),
          initialBalance: Value(initialBalance),
          isArchived: Value(isArchived),
          createdAt: Value(createdAt),
          updatedAt: Value(updatedAt),
          createdBy: Value(createdBy),
          updatedBy: Value(updatedBy),
        ),
      );
    }
  }

  Future<void> _syncTransactions({
    required List<Map<String, dynamic>> cloudTransactions,
  }) async {
    for (final transaction in cloudTransactions) {
      await _resolveLocalTransaction(
        id: transaction['id'] as String,
        householdId: transaction['householdId'] as String,
        type: TransactionType.values.byName(
          transaction['type'] as String,
        ),
        expenseType: transaction['expenseType'] != null
            ? ExpenseType.values.byName(
                transaction['expenseType'] as String,
              )
            : null,
        amount: (transaction['amount'] as num).toInt(),
        sourceAccountId: transaction['sourceAccountId'] as String?,
        destinationAccountId: transaction['destinationAccountId'] as String?,
        categoryId: transaction['categoryId'] as String?,
        description: transaction['description'] as String?,
        transactionDate: (transaction['transactionDate'] as Timestamp).toDate(),
        createdBy: transaction['createdBy'] as String,
        updatedBy: transaction['updatedBy'] as String,
        createdAt: (transaction['createdAt'] as Timestamp).toDate(),
        updatedAt: (transaction['updatedAt'] as Timestamp).toDate(),
        syncStatus: SyncStatus.values.byName(
          transaction['syncStatus'] as String,
        ),
        isDeleted: transaction['isDeleted'] as bool,
      );
    }
  }

  Future<void> _resolveLocalTransaction({
    required String id,
    required String householdId,
    required TransactionType type,
    required ExpenseType? expenseType,
    required int amount,
    required String? sourceAccountId,
    required String? destinationAccountId,
    required String? categoryId,
    required String? description,
    required DateTime transactionDate,
    required String createdBy,
    required String updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SyncStatus syncStatus,
    required bool isDeleted,
  }) async {
    final existingTransaction = await (_database.select(_database.transactions)
          ..where((transaction) => transaction.id.equals(id)))
        .getSingleOrNull();

    if (existingTransaction == null) {
      await _database.into(_database.transactions).insert(
            TransactionsCompanion.insert(
              id: id,
              householdId: householdId,
              type: type,
              expenseType: Value(expenseType),
              amount: amount,
              sourceAccountId: Value(sourceAccountId),
              destinationAccountId: Value(destinationAccountId),
              categoryId: Value(categoryId),
              description: Value(description),
              transactionDate: transactionDate,
              createdBy: createdBy,
              updatedBy: updatedBy,
              createdAt: createdAt,
              updatedAt: updatedAt,
              syncStatus: syncStatus,
              isDeleted: Value(isDeleted),
            ),
          );
    } else {
      await (_database.update(_database.transactions)
            ..where((transaction) => transaction.id.equals(id)))
          .write(
        TransactionsCompanion(
          householdId: Value(householdId),
          type: Value(type),
          expenseType: Value(expenseType),
          amount: Value(amount),
          sourceAccountId: Value(sourceAccountId),
          destinationAccountId: Value(destinationAccountId),
          categoryId: Value(categoryId),
          description: Value(description),
          transactionDate: Value(transactionDate),
          createdBy: Value(createdBy),
          updatedBy: Value(updatedBy),
          createdAt: Value(createdAt),
          updatedAt: Value(updatedAt),
          syncStatus: Value(syncStatus),
          isDeleted: Value(isDeleted),
        ),
      );
    }
  }
}
