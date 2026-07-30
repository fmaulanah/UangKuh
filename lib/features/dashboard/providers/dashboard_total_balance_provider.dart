import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../account/providers/account_repository_provider.dart';
import '../../auth/providers/app_session_provider.dart';

final dashboardTotalBalanceProvider = FutureProvider<int>((ref) async {
  final session = ref.watch(appSessionProvider);

  if (session == null) {
    return 0;
  }

  final repository = ref.watch(
    accountRepositoryProvider,
  );

  return repository.getTotalBalance(
    session.householdId,
  );
});
