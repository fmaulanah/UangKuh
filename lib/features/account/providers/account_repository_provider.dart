import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/drift_account_repository.dart';
import '../domain/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return DriftAccountRepository(database);
});
