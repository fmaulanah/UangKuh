import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/category_repository.dart';
import '../domain/category_type.dart';

class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Category>> getCategories(
    String householdId, {
    CategoryType? type,
  }) {
    final query = _database.select(_database.categories)
      ..where(
        (category) =>
            category.householdId.equals(householdId) &
            category.isArchived.equals(false),
      );

    if (type != null) {
      query.where((category) => category.type.equals(type.name));
    }

    query.orderBy([
      (category) => OrderingTerm.asc(category.name),
    ]);

    return query.get();
  }

  @override
  Future<Category?> getCategoryById(String id) {
    return (_database.select(_database.categories)
          ..where((category) => category.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<void> createCategory({
    required String id,
    required String householdId,
    required String name,
    required CategoryType type,
    required String iconKey,
    required bool isDefault,
    required String userId,
  }) async {
    final trimmedName = name.trim();
    final trimmedIconKey = iconKey.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Category name cannot be empty.');
    }

    if (trimmedIconKey.isEmpty) {
      throw ArgumentError('Category icon key cannot be empty.');
    }

    final now = DateTime.now();

    await _database.into(_database.categories).insert(
          CategoriesCompanion.insert(
            id: id,
            householdId: householdId,
            name: trimmedName,
            type: type,
            iconKey: trimmedIconKey,
            isDefault: Value(isDefault),
            createdAt: now,
            updatedAt: now,
            createdBy: userId,
            updatedBy: userId,
          ),
        );
  }

  @override
  Future<void> updateCategory({
    required String id,
    required String name,
    required String iconKey,
    required String userId,
  }) async {
    final existingCategory = await getCategoryById(id);

    if (existingCategory == null) {
      throw StateError('Category not found.');
    }

    final trimmedName = name.trim();
    final trimmedIconKey = iconKey.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Category name cannot be empty.');
    }

    if (trimmedIconKey.isEmpty) {
      throw ArgumentError('Category icon key cannot be empty.');
    }

    await (_database.update(_database.categories)
          ..where((category) => category.id.equals(id)))
        .write(
      CategoriesCompanion(
        name: Value(trimmedName),
        iconKey: Value(trimmedIconKey),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(userId),
      ),
    );
  }

  @override
  Future<void> archiveCategory({
    required String id,
    required String userId,
  }) async {
    final existingCategory = await getCategoryById(id);

    if (existingCategory == null) {
      throw StateError('Category not found.');
    }

    await (_database.update(_database.categories)
          ..where((category) => category.id.equals(id)))
        .write(
      CategoriesCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(userId),
      ),
    );
  }
}
