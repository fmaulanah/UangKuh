import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/firebase/firestore_repository_provider.dart';

import '../data/local_session_bootstrap.dart';
import '../domain/app_session.dart';

final localSessionBootstrapProvider = Provider<LocalSessionBootstrap>((ref) {
  final database = ref.watch(databaseProvider);
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);

  return LocalSessionBootstrap(
    database,
    firestoreRepository,
  );
});

final appSessionProvider = StateProvider<AppSession?>(
  (ref) => null,
);
