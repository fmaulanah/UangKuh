import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_provider.dart';
import '../firebase/firestore_repository_provider.dart';

import 'firebase_sync_repository.dart';
import 'sync_repository.dart';

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final database = ref.watch(databaseProvider);

  final firestoreRepository = ref.watch(
    firestoreRepositoryProvider,
  );

  return FirebaseSyncRepository(
    database,
    firestoreRepository,
  );
});
