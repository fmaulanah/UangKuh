import 'package:drift/drift.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/database/app_database.dart';
import '../../../core/firebase/firestore_repository.dart';
import '../domain/app_session.dart';

import '../../household/domain/household_role.dart';
import '../../category/domain/category_type.dart';

class LocalSessionBootstrap {
  LocalSessionBootstrap(
    this._database,
    this._firestoreRepository,
  );

  final AppDatabase _database;
  final FirestoreRepository _firestoreRepository;

  static const List<
      ({
        String id,
        String name,
        CategoryType type,
        String iconKey,
      })> _defaultCategories = [
    (
      id: 'default-expense-food-drink',
      name: 'Food & Drink',
      type: CategoryType.expense,
      iconKey: 'food_drink',
    ),
    (
      id: 'default-expense-transport',
      name: 'Transport',
      type: CategoryType.expense,
      iconKey: 'transport',
    ),
    (
      id: 'default-expense-household',
      name: 'Household',
      type: CategoryType.expense,
      iconKey: 'household',
    ),
    (
      id: 'default-expense-bills',
      name: 'Bills',
      type: CategoryType.expense,
      iconKey: 'bills',
    ),
    (
      id: 'default-expense-shopping',
      name: 'Shopping',
      type: CategoryType.expense,
      iconKey: 'shopping',
    ),
    (
      id: 'default-expense-health',
      name: 'Health',
      type: CategoryType.expense,
      iconKey: 'health',
    ),
    (
      id: 'default-expense-entertainment',
      name: 'Entertainment',
      type: CategoryType.expense,
      iconKey: 'entertainment',
    ),
    (
      id: 'default-expense-personal',
      name: 'Personal',
      type: CategoryType.expense,
      iconKey: 'personal',
    ),
    (
      id: 'default-expense-other',
      name: 'Other',
      type: CategoryType.expense,
      iconKey: 'other',
    ),
    (
      id: 'default-income-salary',
      name: 'Salary',
      type: CategoryType.income,
      iconKey: 'salary',
    ),
    (
      id: 'default-income-freelance',
      name: 'Freelance',
      type: CategoryType.income,
      iconKey: 'freelance',
    ),
    (
      id: 'default-income-bonus',
      name: 'Bonus',
      type: CategoryType.income,
      iconKey: 'bonus',
    ),
    (
      id: 'default-income-other',
      name: 'Other Income',
      type: CategoryType.income,
      iconKey: 'other_income',
    ),
  ];

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

    await _seedDefaultCategories(
      householdId: household.id,
      userId: user.id,
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

    // await _resolveLocalMembership(
    //   memberId: _localMemberId,
    //   householdId: household.id,
    //   userId: createdBy,
    //   role: HouseholdRole.owner,
    //   joinedAt: DateTime.now(),
    // );

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

  Future<void> _seedDefaultCategories({
    required String householdId,
    required String userId,
  }) async {
    final existingCategories = await (_database.select(_database.categories)
          ..where(
            (category) => category.householdId.equals(householdId),
          ))
        .get();

    final existingIds =
        existingCategories.map((category) => category.id).toSet();

    final now = DateTime.now();

    for (final category in _defaultCategories) {
      if (existingIds.contains(category.id)) {
        continue;
      }

      await _database.into(_database.categories).insert(
            CategoriesCompanion.insert(
              id: category.id,
              householdId: householdId,
              name: category.name,
              type: category.type,
              iconKey: category.iconKey,
              isDefault: const Value(true),
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );
    }
  }
}
