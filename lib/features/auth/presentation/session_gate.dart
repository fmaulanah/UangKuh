import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_session.dart';
import '../providers/app_session_provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class SessionGate extends ConsumerStatefulWidget {
  const SessionGate({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  ConsumerState<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends ConsumerState<SessionGate> {
  Object? _error;
  bool _initialized = false;

  Future<void> _initializeSession(AppSession firebaseSession) async {
    try {
      final bootstrap = ref.read(localSessionBootstrapProvider);

      final session = await bootstrap.bootstrap(
        userId: firebaseSession.userId,
        email: firebaseSession.email,
        displayName: firebaseSession.displayName,
      );

      if (!mounted) return;

      ref.read(appSessionProvider.notifier).state = session;
    } catch (error) {
      debugPrint('SESSION BOOTSTRAP ERROR: $error');

      if (!mounted) return;

      setState(() {
        _error = error;
        _initialized = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final session = ref.watch(appSessionProvider);

    return StreamBuilder<AppSession?>(
      stream: authRepository.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SessionLoading();
        }

        final firebaseSession = snapshot.data;

        // ==========================
        // Belum Login
        // ==========================
        if (firebaseSession == null) {
          _initialized = false;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(appSessionProvider.notifier).state = null;
          });

          return const LoginPage();
        }

        // ==========================
        // Sudah Login
        // ==========================
        if (!_initialized) {
          _initialized = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeSession(firebaseSession);
          });
        }

        if (_error != null) {
          return _SessionError(
            onRetry: () {
              setState(() {
                _error = null;
                _initialized = false;
              });
            },
          );
        }

        if (session == null) {
          return const _SessionLoading();
        }

        return widget.child;
      },
    );
  }
}

class _SessionLoading extends StatelessWidget {
  const _SessionLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _SessionError extends StatelessWidget {
  const _SessionError({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Unable to initialize UangKuh.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Please try again.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
