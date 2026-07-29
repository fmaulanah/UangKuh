import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/app_session_provider.dart';
import '../domain/category_type.dart';
import '../providers/category_list_provider.dart';
import '../providers/category_repository_provider.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  const CategoryFormScreen({
    this.categoryId,
    super.key,
  });

  final String? categoryId;

  bool get isEditing => categoryId != null;

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  CategoryType _type = CategoryType.expense;
  String _iconKey = 'category';

  bool _isSaving = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      _isLoading = true;
      Future.microtask(_loadCategory);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Category'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Category' : 'Add Category',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                enabled: !_isSaving,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Category name',
                  hintText: 'e.g. Hobby, Education',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category name is required.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CategoryType>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Category type',
                  border: OutlineInputBorder(),
                ),
                items: CategoryType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_categoryTypeLabel(type)),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving || widget.isEditing
                    ? null
                    : (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          _type = value;
                        });
                      },
              ),
              const SizedBox(height: 24),
              Text(
                'Icon',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _icons.map((option) {
                  final selected = _iconKey == option.key;

                  return ChoiceChip(
                    selected: selected,
                    avatar: Icon(option.icon),
                    label: Text(option.label),
                    onSelected: _isSaving
                        ? null
                        : (_) {
                            setState(() {
                              _iconKey = option.key;
                            });
                          },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.isEditing ? 'Save Changes' : 'Save Category',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final session = ref.read(appSessionProvider);

    if (session == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(categoryRepositoryProvider);

      if (widget.isEditing) {
        await repository.updateCategory(
          id: widget.categoryId!,
          name: _nameController.text,
          iconKey: _iconKey,
          userId: session.userId,
        );
      } else {
        await repository.createCategory(
          id: _generateId(),
          householdId: session.householdId,
          name: _nameController.text,
          type: _type,
          iconKey: _iconKey,
          isDefault: false,
          userId: session.userId,
        );
      }

      ref.invalidate(categoryListProvider);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Unable to update category.'
                : 'Unable to create category.',
          ),
        ),
      );

      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _loadCategory() async {
    try {
      final repository = ref.read(categoryRepositoryProvider);

      final category = await repository.getCategoryById(
        widget.categoryId!,
      );

      if (!mounted) {
        return;
      }

      if (category == null) {
        Navigator.of(context).pop();
        return;
      }

      _nameController.text = category.name;

      setState(() {
        _type = category.type;
        _iconKey = category.iconKey;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    }
  }

  String _generateId() {
    return 'category-${DateTime.now().microsecondsSinceEpoch}';
  }
}

String _categoryTypeLabel(CategoryType type) {
  return switch (type) {
    CategoryType.expense => 'Expense',
    CategoryType.income => 'Income',
  };
}

class _CategoryIconOption {
  const _CategoryIconOption({
    required this.key,
    required this.label,
    required this.icon,
  });

  final String key;
  final String label;
  final IconData icon;
}

const _icons = [
  _CategoryIconOption(
    key: 'category',
    label: 'General',
    icon: Icons.category_outlined,
  ),
  _CategoryIconOption(
    key: 'education',
    label: 'Education',
    icon: Icons.school_outlined,
  ),
  _CategoryIconOption(
    key: 'hobby',
    label: 'Hobby',
    icon: Icons.sports_esports_outlined,
  ),
  _CategoryIconOption(
    key: 'travel',
    label: 'Travel',
    icon: Icons.flight_outlined,
  ),
  _CategoryIconOption(
    key: 'gift',
    label: 'Gift',
    icon: Icons.card_giftcard_outlined,
  ),
  _CategoryIconOption(
    key: 'business',
    label: 'Business',
    icon: Icons.business_center_outlined,
  ),
];
