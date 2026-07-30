import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/models/recurring_plan_item.dart';
import 'recurring_list_provider.dart';
import 'recurring_repository_provider.dart';

final recurringPlanProvider =
    FutureProvider<List<RecurringPlanItem>>((ref) async {
  final recurringExpenses = await ref.watch(
    recurringListProvider.future,
  );

  final repository = ref.watch(
    recurringRepositoryProvider,
  );

  final now = DateTime.now();

  final items = <RecurringPlanItem>[];

  for (final recurring in recurringExpenses) {
    final payment = await repository.getRecurringPaymentForPeriod(
      recurringExpenseId: recurring.id,
      periodYear: now.year,
      periodMonth: now.month,
    );

    items.add(
      RecurringPlanItem(
        recurringExpense: recurring,
        payment: payment,
      ),
    );
  }

  return items;
});
