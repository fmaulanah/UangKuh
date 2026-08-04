import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'provisioning_provider.dart';

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
  }) async {
    try {
      _ref.read(isProvisioningProvider.notifier).state = true;

      final authRepository = _ref.read(authRepositoryProvider);
      final firestoreRepository = _ref.read(firestoreRepositoryProvider);

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
    } finally {
      _ref.read(isProvisioningProvider.notifier).state = false;
    }
  }

  Future<void> signOut() {
    return _ref.read(authRepositoryProvider).signOut();
  }
}
