import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_session_provider.dart';

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

  @override
  void initState() {
    super.initState();

    Future.microtask(_initializeSession);
  }

  Future<void> _initializeSession() async {
    try {
      final bootstrap = ref.read(localSessionBootstrapProvider);

      final session = await bootstrap.bootstrap();

      if (!mounted) {
        return;
      }

      ref.read(appSessionProvider.notifier).state = session;
    } catch (error) {
      debugPrint('SESSION BOOTSTRAP ERROR: $error');

      if (!mounted) {
        return;
      }

      setState(() {
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(appSessionProvider);

    if (_error != null) {
      return _SessionError(
        onRetry: () {
          setState(() {
            _error = null;
          });

          _initializeSession();
        },
      );
    }

    if (session == null) {
      return const _SessionLoading();
    }

    return widget.child;
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
              const SizedBox(height: 16),
              Text(
                'Unable to initialize UangKuh.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please try again.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
