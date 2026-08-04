import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/firebase/firestore_repository_provider.dart';

import '../data/session_bootstrap.dart';
import '../domain/app_session.dart';

final sessionBootstrapProvider = Provider<SessionBootstrap>((ref) {
  final database = ref.watch(databaseProvider);
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);

  return SessionBootstrap(
    database,
    firestoreRepository,
  );
});

final appSessionProvider = StateProvider<AppSession?>(
  (ref) => null,
);
