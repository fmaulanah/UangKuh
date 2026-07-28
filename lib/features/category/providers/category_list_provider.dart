import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../auth/providers/app_session_provider.dart';
import 'category_repository_provider.dart';

final categoryListProvider = FutureProvider<List<Category>>((ref) async {
  final session = ref.watch(appSessionProvider);

  if (session == null) {
    return const [];
  }

  final repository = ref.watch(categoryRepositoryProvider);

  return repository.getCategories(
    session.householdId,
  );
});
