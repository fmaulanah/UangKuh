import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'provisioning_provider.dart';
import 'app_session_provider.dart';

import '../../../core/firebase/firestore_repository_provider.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  AuthController(this._ref);

  final Ref _ref;

  Future<void> signIn({
    required String email,
    required String password,
  }) {
    return _ref.read(authRepositoryProvider).signIn(
          email: email,
          password: password,
        );
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    bool joinExistingHousehold = false,
    String? inviteCode,
  }) async {
    try {
      _ref.read(isProvisioningProvider.notifier).state = true;

      final authRepository = _ref.read(authRepositoryProvider);
      final firestoreRepository = _ref.read(firestoreRepositoryProvider);

      String? joinedHouseholdId;

      if (joinExistingHousehold) {
        final normalizedInviteCode = inviteCode?.trim() ?? '';

        if (normalizedInviteCode.isEmpty) {
          throw StateError('Invalid invite code.');
        }

        final household = await firestoreRepository.getHouseholdByInviteCode(
          inviteCode: normalizedInviteCode,
        );

        if (household == null) {
          throw StateError('Invalid invite code.');
        }

        joinedHouseholdId = household['id'] as String?;

        if (joinedHouseholdId == null || joinedHouseholdId.isEmpty) {
          throw StateError('Invalid household data.');
        }
      }

      final session = await authRepository.register(
        email: email,
        password: password,
        displayName: displayName,
      );

      await firestoreRepository.createUser(
        uid: session.userId,
        email: session.email,
        displayName: session.displayName,
      );

      if (joinExistingHousehold) {
        await firestoreRepository.createMember(
          householdId: joinedHouseholdId!,
          userId: session.userId,
        );

        await firestoreRepository.updateDefaultHousehold(
          uid: session.userId,
          householdId: joinedHouseholdId,
        );
      } else {
        final householdId = await firestoreRepository.createHousehold(
          ownerId: session.userId,
          householdName: "${session.displayName}'s Household",
        );

        await firestoreRepository.createHouseholdMember(
          householdId: householdId,
          userId: session.userId,
        );

        await firestoreRepository.updateDefaultHousehold(
          uid: session.userId,
          householdId: householdId,
        );
      }

      final appSession = await _ref.read(sessionBootstrapProvider).bootstrap(
            userId: session.userId,
            email: session.email,
            displayName: session.displayName,
          );

      _ref.read(appSessionProvider.notifier).state = appSession;
    } finally {
      _ref.read(isProvisioningProvider.notifier).state = false;
    }
  }

  Future<void> signOut() {
    return _ref.read(authRepositoryProvider).signOut();
  }

  Future<String> joinHousehold({
    required String inviteCode,
    required String userId,
  }) async {
    final normalizedInviteCode = inviteCode.trim();

    if (normalizedInviteCode.isEmpty) {
      throw StateError('Invalid invite code.');
    }

    final firestoreRepository = _ref.read(firestoreRepositoryProvider);
    final household = await firestoreRepository.getHouseholdByInviteCode(
      inviteCode: normalizedInviteCode,
    );

    if (household == null) {
      throw StateError('Invalid invite code.');
    }

    final householdId = household['id'] as String?;

    if (householdId == null || householdId.isEmpty) {
      throw StateError('Invalid household data.');
    }

    await firestoreRepository.createMember(
      householdId: householdId,
      userId: userId,
    );

    await firestoreRepository.updateDefaultHousehold(
      uid: userId,
      householdId: householdId,
    );

    return householdId;
  }
}
