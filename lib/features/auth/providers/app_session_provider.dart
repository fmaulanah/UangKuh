import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/local_session_bootstrap.dart';
import '../domain/app_session.dart';

final localSessionBootstrapProvider = Provider<LocalSessionBootstrap>((ref) {
  final database = ref.watch(databaseProvider);

  return LocalSessionBootstrap(database);
});

final appSessionProvider = StateProvider<AppSession?>(
  (ref) => null,
);
