import '../../../core/database/app_database.dart';
import 'category_type.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories(
    String householdId, {
    CategoryType? type,
  });

  Future<Category?> getCategoryById(String id);

  Future<void> createCategory({
    required String id,
    required String householdId,
    required String name,
    required CategoryType type,
    required String iconKey,
    required bool isDefault,
    required String userId,
  });

  Future<void> updateCategory({
    required String id,
    required String name,
    required String iconKey,
    required String userId,
  });

  Future<void> archiveCategory({
    required String id,
    required String userId,
  });
}
