import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/app_session.dart';

import '../../household/domain/household_role.dart';
import '../../category/domain/category_type.dart';

class LocalSessionBootstrap {
  LocalSessionBootstrap(this._database);

  final AppDatabase _database;

  static const String _localHouseholdId = 'local-household';
  static const String _localMemberId = 'local-member';

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
    final user = await _resolveLocalUser(
      userId: userId,
      email: email,
      displayName: displayName,
    );

    final household = await _resolveLocalHousehold(user.id);

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

    if (existingUser != null) {
      return existingUser;
    }

    final now = DateTime.now();

    final user = UsersCompanion.insert(
      id: userId,
      email: email,
      displayName: displayName,
      createdAt: now,
      updatedAt: now,
    );

    await _database.into(_database.users).insert(user);

    return (_database.select(_database.users)
          ..where((user) => user.id.equals(userId)))
        .getSingle();
  }

  Future<Household> _resolveLocalHousehold(String userId) async {
    final existingHousehold = await (_database.select(_database.households)
          ..where(
            (household) => household.id.equals(_localHouseholdId),
          ))
        .getSingleOrNull();

    Household household;

    if (existingHousehold != null) {
      household = existingHousehold;
    } else {
      final now = DateTime.now();

      await _database.into(_database.households).insert(
            HouseholdsCompanion.insert(
              id: _localHouseholdId,
              name: 'My Household',
              inviteCode: 'LOCAL',
              createdBy: userId,
              createdAt: now,
              updatedAt: now,
            ),
          );

      household = await (_database.select(_database.households)
            ..where(
              (household) => household.id.equals(_localHouseholdId),
            ))
          .getSingle();
    }

    await _resolveLocalMembership(
      userId: userId,
      householdId: household.id,
    );

    return household;
  }

  Future<void> _resolveLocalMembership({
    required String userId,
    required String householdId,
  }) async {
    final existingMembership =
        await (_database.select(_database.householdMembers)
              ..where(
                (member) => member.userId.equals(userId),
              ))
            .getSingleOrNull();

    if (existingMembership != null) {
      return;
    }

    await _database.into(_database.householdMembers).insert(
          HouseholdMembersCompanion.insert(
            id: _localMemberId,
            householdId: householdId,
            userId: userId,
            role: HouseholdRole.owner,
            joinedAt: DateTime.now(),
          ),
        );
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
