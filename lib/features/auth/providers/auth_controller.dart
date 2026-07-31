import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

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
  }) {
    return _ref.read(authRepositoryProvider).register(
          email: email,
          password: password,
          displayName: displayName,
        );
  }

  Future<void> signOut() {
    return _ref.read(authRepositoryProvider).signOut();
  }
}
