import 'package:drift/drift.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/database/app_database.dart';
import '../../../core/firebase/firestore_repository.dart';
import '../domain/app_session.dart';

import '../../household/domain/household_role.dart';
import '../../category/domain/category_type.dart';

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
}
