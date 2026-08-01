import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../utils/invite_code_generator.dart';

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
}
