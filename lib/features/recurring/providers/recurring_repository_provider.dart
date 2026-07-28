import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/drift_recurring_repository.dart';
import '../domain/recurring_repository.dart';

final recurringRepositoryProvider = Provider<RecurringRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return DriftRecurringRepository(database);
});
