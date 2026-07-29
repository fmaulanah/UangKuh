import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/category_type.dart';
import '../providers/category_list_provider.dart';

import '../../../core/database/app_database.dart';
import '../../auth/providers/app_session_provider.dart';
import '../providers/category_repository_provider.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            tooltip: 'Add category',
            onPressed: () {
              context.push('/me/categories/new');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => _CategoryError(
          onRetry: () {
            ref.invalidate(categoryListProvider);
          },
        ),
        data: (categories) {
          final expenseCategories = categories
              .where(
                (category) => category.type == CategoryType.expense,
              )
              .toList();

          final incomeCategories = categories
              .where(
                (category) => category.type == CategoryType.income,
              )
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(categoryListProvider);

              await ref.read(categoryListProvider.future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _CategorySection(
                  title: 'Expense',
                  categories: expenseCategories,
                  onArchive: (category) {
                    _archiveCategory(
                      context,
                      ref,
                      category,
                    );
                  },
                ),
                const SizedBox(height: 24),
                _CategorySection(
                  title: 'Income',
                  categories: incomeCategories,
                  onArchive: (category) {
                    _archiveCategory(
                      context,
                      ref,
                      category,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _archiveCategory(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    if (category.isDefault) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Archive category?'),
          content: Text(
            'Archive "${category.name}"? '
            'The category will be hidden from your active categories.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Archive'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final session = ref.read(appSessionProvider);

    if (session == null) {
      return;
    }

    try {
      final repository = ref.read(categoryRepositoryProvider);

      await repository.archiveCategory(
        id: category.id,
        userId: session.userId,
      );

      ref.invalidate(categoryListProvider);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to archive category.'),
        ),
      );
    }
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.categories,
    required this.onArchive,
  });

  final String title;
  final List<Category> categories;
  final void Function(Category category) onArchive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        if (categories.isEmpty)
          Text(
            'No $title categories.',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          ...categories.map(
            (category) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    _categoryIcon(category.iconKey),
                  ),
                ),
                title: Text(category.name),
                subtitle: Text(
                  category.isDefault ? 'System category' : 'Custom category',
                ),
                trailing: category.isDefault
                    ? const Text('Default')
                    : PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'archive') {
                            onArchive(category);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'archive',
                            child: Row(
                              children: [
                                Icon(Icons.archive_outlined),
                                SizedBox(width: 12),
                                Text('Archive'),
                              ],
                            ),
                          ),
                        ],
                      ),
                onTap: category.isDefault
                    ? null
                    : () {
                        context.push(
                          '/me/categories/${category.id}/edit',
                        );
                      },
              ),
            ),
          ),
      ],
    );
  }
}

class _CategoryError extends StatelessWidget {
  const _CategoryError({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load categories.',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _categoryIcon(String iconKey) {
  return switch (iconKey) {
    'food_drink' => Icons.restaurant_outlined,
    'transport' => Icons.directions_car_outlined,
    'household' => Icons.home_outlined,
    'bills' => Icons.receipt_long_outlined,
    'shopping' => Icons.shopping_bag_outlined,
    'health' => Icons.medical_services_outlined,
    'entertainment' => Icons.movie_outlined,
    'personal' => Icons.person_outline,
    'salary' => Icons.work_outline,
    'freelance' => Icons.laptop_outlined,
    'bonus' => Icons.card_giftcard_outlined,
    'other_income' => Icons.add_card_outlined,
    'category' => Icons.category_outlined,
    'education' => Icons.school_outlined,
    'hobby' => Icons.sports_esports_outlined,
    'travel' => Icons.flight_outlined,
    'gift' => Icons.card_giftcard_outlined,
    'business' => Icons.business_center_outlined,
    _ => Icons.category_outlined,
  };
}
