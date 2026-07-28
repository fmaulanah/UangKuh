import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/app_session_provider.dart';
import '../presentation/account_list_item.dart';
import 'account_repository_provider.dart';

final accountListProvider = FutureProvider<List<AccountListItem>>((ref) async {
  final session = ref.watch(appSessionProvider);

  if (session == null) {
    return const [];
  }

  final repository = ref.watch(accountRepositoryProvider);

  final accounts = await repository.getAccounts(
    session.householdId,
  );

  final items = <AccountListItem>[];

  for (final account in accounts) {
    final currentBalance = await repository.getCurrentBalance(
      account.id,
    );

    items.add(
      AccountListItem(
        account: account,
        currentBalance: currentBalance,
      ),
    );
  }

  return items;
});
