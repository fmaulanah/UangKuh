import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recurring_list_provider.dart';
import '../providers/recurring_repository_provider.dart';

import '../../auth/providers/app_session_provider.dart';
import '../../account/providers/account_list_provider.dart';
import '../../category/domain/category_type.dart';
import '../../category/providers/category_list_provider.dart';

class RecurringFormScreen extends ConsumerStatefulWidget {
  const RecurringFormScreen({
    this.recurringId,
    super.key,
  });

  final String? recurringId;

  bool get isEditing => recurringId != null;

  @override
  ConsumerState<RecurringFormScreen> createState() =>
      _RecurringFormScreenState();
}

class _RecurringFormLoadError extends StatelessWidget {
  const _RecurringFormLoadError({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load recurring expense.',
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

class _RecurringFormScreenState extends ConsumerState<RecurringFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDayController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedAccountId;

  bool _isSaving = false;
  bool _isLoading = false;
  bool _isDeactivating = false;

  Object? _loadError;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      Future.microtask(_loadRecurringExpense);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dueDayController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(
      categoryListProvider,
    );

    final accountsAsync = ref.watch(
      accountListProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Recurring Expense' : 'New Recurring Expense',
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _loadError != null
              ? _RecurringFormLoadError(
                  onRetry: _loadRecurringExpense,
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    // isi form existing lu
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'e.g. Internet, Car Payment',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Default amount',
                          prefixText: 'Rp ',
                        ),
                        validator: (value) {
                          final amount = int.tryParse(
                            value?.trim() ?? '',
                          );

                          if (amount == null || amount <= 0) {
                            return 'Enter a valid amount.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      categoriesAsync.when(
                        loading: () => DropdownButtonFormField<String>(
                          items: [],
                          onChanged: null,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            hintText: 'Loading categories...',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Category is required.';
                            }

                            return null;
                          },
                        ),
                        error: (error, stackTrace) =>
                            DropdownButtonFormField<String>(
                          items: [],
                          onChanged: null,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            hintText: 'Unable to load categories',
                          ),
                        ),
                        data: (categories) {
                          final expenseCategories = categories
                              .where(
                                (category) =>
                                    category.type == CategoryType.expense,
                              )
                              .toList();

                          return DropdownButtonFormField<String>(
                            value: _selectedCategoryId,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              hintText: 'Select expense category',
                            ),
                            items: expenseCategories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Text(category.name),
                                  ),
                                )
                                .toList(),
                            onChanged: expenseCategories.isEmpty
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedCategoryId = value;
                                    });
                                  },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      accountsAsync.when(
                        loading: () => DropdownButtonFormField<String>(
                          items: [],
                          onChanged: null,
                          decoration: InputDecoration(
                            labelText: 'Default account',
                            hintText: 'Loading accounts...',
                          ),
                        ),
                        error: (error, stackTrace) =>
                            DropdownButtonFormField<String>(
                          items: [],
                          onChanged: null,
                          decoration: InputDecoration(
                            labelText: 'Default account',
                            hintText: 'Unable to load accounts',
                          ),
                        ),
                        data: (accountItems) {
                          return DropdownButtonFormField<String>(
                            value: _selectedAccountId,
                            decoration: InputDecoration(
                              labelText: 'Default account',
                              hintText: 'Optional',
                              suffixIcon: _selectedAccountId == null
                                  ? null
                                  : IconButton(
                                      tooltip: 'Clear default account',
                                      onPressed: () {
                                        setState(() {
                                          _selectedAccountId = null;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                      ),
                                    ),
                            ),
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('No default account'),
                              ),
                              ...accountItems.map(
                                (item) => DropdownMenuItem<String>(
                                  value: item.account.id,
                                  child: Text(
                                    item.account.name,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedAccountId = value;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dueDayController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Due day',
                          hintText: 'Optional, 1–31',
                        ),
                        validator: (value) {
                          final text = value?.trim() ?? '';

                          if (text.isEmpty) {
                            return null;
                          }

                          final dueDay = int.tryParse(text);

                          if (dueDay == null || dueDay < 1 || dueDay > 31) {
                            return 'Due day must be between 1 and 31.';
                          }

                          return null;
                        },
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
                                widget.isEditing
                                    ? 'Save Changes'
                                    : 'Create Recurring Expense',
                              ),
                      ),
                      if (widget.isEditing) ...[
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _isSaving || _isDeactivating
                              ? null
                              : _confirmDeactivate,
                          icon: _isDeactivating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.archive_outlined,
                                ),
                          label: Text(
                            _isDeactivating
                                ? 'Deactivating...'
                                : 'Deactivate Recurring Expense',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final categoryId = _selectedCategoryId;

    if (categoryId == null) {
      return;
    }

    final session = ref.read(appSessionProvider);

    if (session == null) {
      return;
    }

    final amount = int.parse(
      _amountController.text.trim(),
    );

    final dueDayText = _dueDayController.text.trim();

    final dueDay = dueDayText.isEmpty ? null : int.parse(dueDayText);

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(
        recurringRepositoryProvider,
      );

      if (widget.isEditing) {
        await repository.updateRecurringExpense(
          id: widget.recurringId!,
          name: _nameController.text.trim(),
          defaultAmount: amount,
          categoryId: categoryId,
          defaultAccountId: _selectedAccountId,
          dueDay: dueDay,
          userId: session.userId,
        );
      } else {
        await repository.createRecurringExpense(
          id: _generateRecurringExpenseId(),
          householdId: session.householdId,
          name: _nameController.text.trim(),
          defaultAmount: amount,
          categoryId: categoryId,
          defaultAccountId: _selectedAccountId,
          dueDay: dueDay,
          userId: session.userId,
        );
      }

      ref.invalidate(recurringListProvider);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(
        widget.isEditing
            ? 'UPDATE RECURRING EXPENSE ERROR: $error'
            : 'CREATE RECURRING EXPENSE ERROR: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Unable to update recurring expense.'
                : 'Unable to create recurring expense.',
          ),
        ),
      );
    }
  }

  Future<void> _loadRecurringExpense() async {
    final id = widget.recurringId;

    if (id == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final repository = ref.read(
        recurringRepositoryProvider,
      );

      final recurring = await repository.getRecurringExpenseById(id);

      if (recurring == null) {
        throw StateError(
          'Recurring expense not found.',
        );
      }

      if (!mounted) {
        return;
      }

      _nameController.text = recurring.name;

      _amountController.text = recurring.defaultAmount.toString();

      _dueDayController.text = recurring.dueDay?.toString() ?? '';

      setState(() {
        _selectedCategoryId = recurring.categoryId;
        _selectedAccountId = recurring.defaultAccountId;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint(
        'LOAD RECURRING EXPENSE ERROR: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _loadError = error;
      });
    }
  }

  Future<void> _confirmDeactivate() async {
    if (!widget.isEditing) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Deactivate recurring expense?',
          ),
          content: const Text(
            'This recurring expense will be removed from '
            'your active plan. Existing transactions and '
            'payment history will not be deleted.',
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
              child: const Text('Deactivate'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await _deactivate();
  }

  Future<void> _deactivate() async {
    final recurringId = widget.recurringId;

    if (recurringId == null) {
      return;
    }

    final session = ref.read(appSessionProvider);

    if (session == null) {
      return;
    }

    setState(() {
      _isDeactivating = true;
    });

    try {
      final repository = ref.read(
        recurringRepositoryProvider,
      );

      await repository.deactivateRecurringExpense(
        id: recurringId,
        userId: session.userId,
      );

      ref.invalidate(recurringListProvider);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(
        'DEACTIVATE RECURRING EXPENSE ERROR: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isDeactivating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to deactivate recurring expense.',
          ),
        ),
      );
    }
  }
}

String _generateRecurringExpenseId() {
  return 'recurring-${DateTime.now().microsecondsSinceEpoch}';
}
