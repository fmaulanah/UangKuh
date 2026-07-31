import '../domain/app_session.dart';

abstract class AuthRepository {
  /// Login menggunakan email & password.
  Future<AppSession> signIn({
    required String email,
    required String password,
  });

  /// Register user baru.
  Future<AppSession> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Logout user.
  Future<void> signOut();

  /// Session user yang sedang login.
  Stream<AppSession?> authStateChanges();
}
