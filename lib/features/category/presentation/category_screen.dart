import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/category_type.dart';
import '../providers/category_list_provider.dart';

import '../../../core/database/app_database.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
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
                ),
                const SizedBox(height: 24),
                _CategorySection(
                  title: 'Income',
                  categories: incomeCategories,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.categories,
  });

  final String title;
  final List<Category> categories;

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
                trailing: category.isDefault ? const Text('Default') : null,
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
    _ => Icons.category_outlined,
  };
}
