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
}
