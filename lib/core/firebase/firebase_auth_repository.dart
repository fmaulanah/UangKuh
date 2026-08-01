import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/domain/app_session.dart';
import '../../features/auth/data/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<AppSession> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Failed to sign in.');
    }

    return AppSession(
      userId: user.uid,
      householdId: '',
      email: user.email ?? '',
      displayName: user.displayName ?? '',
    );
  }

  @override
  Future<AppSession> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Failed to create user.');
    }

    await user.updateDisplayName(displayName);
    await user.reload();

    final refreshedUser = _firebaseAuth.currentUser!;

    return AppSession(
      userId: refreshedUser.uid,
      householdId: '',
      email: refreshedUser.email ?? '',
      displayName: refreshedUser.displayName ?? '',
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<AppSession?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return AppSession(
        userId: user.uid,
        householdId: '',
        email: user.email ?? '',
        displayName: user.displayName ?? '',
      );
    });
  }
}
