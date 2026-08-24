import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncStateStatus {
  idle,
  syncing,
  success,
  error,
}

class SyncState {
  const SyncState({
    required this.status,
    this.lastSuccessfulSync,
    this.errorMessage,
  });

  const SyncState.idle({
    DateTime? lastSuccessfulSync,
  }) : this(
          status: SyncStateStatus.idle,
          lastSuccessfulSync: lastSuccessfulSync,
        );

  final SyncStateStatus status;
  final DateTime? lastSuccessfulSync;
  final String? errorMessage;
}

final syncStateProvider = StateProvider<SyncState>(
  (ref) => const SyncState.idle(),
);
