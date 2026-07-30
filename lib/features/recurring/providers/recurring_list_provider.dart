import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../auth/providers/app_session_provider.dart';
import 'recurring_repository_provider.dart';

final recurringListProvider =
    FutureProvider<List<RecurringExpense>>((ref) async {
  final session = ref.watch(appSessionProvider);

  if (session == null) {
    return [];
  }

  final repository = ref.watch(
    recurringRepositoryProvider,
  );

  return repository.getActiveRecurringExpenses(
    session.householdId,
  );
});
