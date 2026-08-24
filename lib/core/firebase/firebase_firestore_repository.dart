import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../utils/invite_code_generator.dart';
import '../constants/default_categories.dart';

import '../../features/category/domain/category_type.dart';
import '../../features/account/domain/account_type.dart';
import '../../features/account/domain/account_purpose.dart';

import 'firestore_repository.dart';

class FirebaseFirestoreRepository implements FirestoreRepository {
  FirebaseFirestoreRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> createUser({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    final document = _firestore.collection('users').doc(uid);

    final snapshot = await document.get();

    if (snapshot.exists) {
      return;
    }

    final now = FieldValue.serverTimestamp();

    await document.set({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'defaultHouseholdId': null,
      'createdAt': now,
      'updatedAt': now,
      'createdBy': uid,
      'updatedBy': uid,
      'isDeleted': false,
      'version': 1,
    });
  }

  @override
  Future<String> createHousehold({
    required String ownerId,
    required String householdName,
  }) async {
    final householdId = const Uuid().v4();
    final inviteCode = InviteCodeGenerator.generate();

    final now = FieldValue.serverTimestamp();

    await _firestore.collection('households').doc(householdId).set({
      'id': householdId,
      'name': householdName,
      'ownerId': ownerId,
      'inviteCode': inviteCode,
      'createdAt': now,
      'updatedAt': now,
      'createdBy': ownerId,
      'updatedBy': ownerId,
      'isDeleted': false,
      'version': 1,
    });

    await _createDefaultCategories(
      householdId: householdId,
      createdBy: ownerId,
    );

    await _createDefaultAccount(
      householdId: householdId,
      createdBy: ownerId,
    );

    return householdId;
  }

  @override
  Future<void> createHouseholdMember({
    required String householdId,
    required String userId,
  }) async {
    final memberId = const Uuid().v4();

    final now = FieldValue.serverTimestamp();

    await _firestore.collection('household_members').doc(memberId).set({
      'id': memberId,
      'householdId': householdId,
      'userId': userId,
      'role': 'owner',
      'joinedAt': now,
      'createdAt': now,
      'updatedAt': now,
      'createdBy': userId,
      'updatedBy': userId,
      'isDeleted': false,
      'version': 1,
    });
  }

  @override
  Future<void> updateDefaultHousehold({
    required String uid,
    required String householdId,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'defaultHouseholdId': householdId,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': uid,
      'version': FieldValue.increment(1),
    });
  }

  @override
  Future<Map<String, dynamic>?> getUser({
    required String uid,
  }) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();

    return snapshot.data();
  }

  @override
  Future<Map<String, dynamic>?> getHousehold({
    required String householdId,
  }) async {
    final snapshot =
        await _firestore.collection('households').doc(householdId).get();

    return snapshot.data();
  }

  @override
  Future<List<Map<String, dynamic>>> getHouseholdMembers({
    required String householdId,
  }) async {
    final snapshot = await _firestore
        .collection('household_members')
        .where('householdId', isEqualTo: householdId)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> createCategory({
    required String householdId,
    required String name,
    required CategoryType type,
    required String iconKey,
    required bool isDefault,
    required String createdBy,
  }) async {
    final doc = _firestore
        .collection('households')
        .doc(householdId)
        .collection('categories')
        .doc();

    final now = FieldValue.serverTimestamp();

    await doc.set({
      'id': doc.id,
      'householdId': householdId,
      'name': name,
      'type': type.name,
      'iconKey': iconKey,
      'isDefault': isDefault,
      'isArchived': false,
      'createdAt': now,
      'updatedAt': now,
      'createdBy': createdBy,
      'updatedBy': createdBy,
    });
  }

  Future<void> _createDefaultCategories({
    required String householdId,
    required String createdBy,
  }) async {
    for (final category in defaultCategories) {
      await createCategory(
        householdId: householdId,
        name: category.name,
        type: category.type,
        iconKey: category.iconKey,
        isDefault: true,
        createdBy: createdBy,
      );
    }
  }

  Future<void> _createDefaultAccount({
    required String householdId,
    required String createdBy,
  }) async {
    await createAccount(
      householdId: householdId,
      name: 'Cash',
      type: AccountType.cash,
      purpose: AccountPurpose.spending,
      initialBalance: 0,
      iconKey: 'cash',
      color: '#4CAF50',
      isDefault: true,
      createdBy: createdBy,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories({
    required String householdId,
  }) async {
    final snapshot = await _firestore
        .collection('households')
        .doc(householdId)
        .collection('categories')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
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
  }) async {
    final doc = _firestore
        .collection('households')
        .doc(householdId)
        .collection('accounts')
        .doc();

    final now = FieldValue.serverTimestamp();

    await doc.set({
      'id': doc.id,
      'householdId': householdId,
      'name': name,
      'type': type.name,
      'purpose': purpose.name,
      'initialBalance': initialBalance,
      'currentBalance': initialBalance,
      'iconKey': iconKey,
      'color': color,
      'isDefault': isDefault,
      'isArchived': false,
      'createdAt': now,
      'updatedAt': now,
      'createdBy': createdBy,
      'updatedBy': createdBy,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getAccounts({
    required String householdId,
  }) async {
    final snapshot = await _firestore
        .collection('households')
        .doc(householdId)
        .collection('accounts')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> createTransaction({
    required Map<String, dynamic> transaction,
  }) async {
    final householdId = transaction['householdId'] as String;

    final doc = _firestore
        .collection('households')
        .doc(householdId)
        .collection('transactions')
        .doc(transaction['id'] as String);

    await doc.set(transaction);
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactions({
    required String householdId,
  }) async {
    final snapshot = await _firestore
        .collection('households')
        .doc(householdId)
        .collection('transactions')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
