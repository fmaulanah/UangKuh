import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/expense_type.dart';
import '../providers/transaction_repository_provider.dart';

import '../../account/providers/account_list_provider.dart';
import '../../auth/providers/app_session_provider.dart';
import '../../category/domain/category_type.dart';
import '../../category/providers/category_repository_provider.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

final _descriptionController = TextEditingController();

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  bool _isLoading = true;
  bool _isSaving = false;

  String? _errorMessage;
  String? _accountId;
  String? _categoryId;

  final _amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ExpenseType _expenseType = ExpenseType.daily;
  DateTime _transactionDate = DateTime.now();

  List<_AccountOption> _accounts = [];
  List<_CategoryOption> _categories = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadOptions);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    try {
      final session = ref.read(appSessionProvider);

      if (session == null) {
        throw StateError('Session is not available.');
      }

      final accountItems = await ref.read(
        accountListProvider.future,
      );

      final categoryRepository = ref.read(
        categoryRepositoryProvider,
      );

      final categories = await categoryRepository.getCategories(
        session.householdId,
        type: CategoryType.expense,
      );

      if (!mounted) {
        return;
      }

      final accounts = accountItems
          .map(
            (item) => _AccountOption(
              id: item.account.id,
              name: item.account.name,
            ),
          )
          .toList();

      final categoryOptions = categories
          .map(
            (category) => _CategoryOption(
              id: category.id,
              name: category.name,
            ),
          )
          .toList();

      setState(() {
        _accounts = accounts;
        _categories = categoryOptions;

        _accountId = accounts.isNotEmpty ? accounts.first.id : null;

        _categoryId =
            categoryOptions.isNotEmpty ? categoryOptions.first.id : null;

        _isLoading = false;
      });
    } catch (error) {
      debugPrint('EXPENSE OPTIONS ERROR: $error');

      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Unable to load expense options.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
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
              Text(_errorMessage!),
            ],
          ),
        ),
      );
    }

    return Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              enabled: !_isSaving,
              validator: (value) {
                final text = value?.trim() ?? '';

                if (text.isEmpty) {
                  return 'Amount is required.';
                }

                final amount = int.tryParse(text);

                if (amount == null) {
                  return 'Enter a valid amount.';
                }

                if (amount <= 0) {
                  return 'Amount must be greater than zero.';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: '0',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _accountId,
              validator: (value) {
                if (value == null) {
                  return 'Select an account.';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'From account',
                border: OutlineInputBorder(),
              ),
              items: _accounts
                  .map(
                    (account) => DropdownMenuItem(
                      value: account.id,
                      child: Text(account.name),
                    ),
                  )
                  .toList(),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      setState(() {
                        _accountId = value;
                      });
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _categoryId,
              validator: (value) {
                if (value == null) {
                  return 'Select an expense category.';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Expense category',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      setState(() {
                        _categoryId = value;
                      });
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExpenseType>(
              value: _expenseType,
              decoration: const InputDecoration(
                labelText: 'Expense type',
                border: OutlineInputBorder(),
              ),
              items: ExpenseType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        _expenseTypeLabel(type),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _expenseType = value;
                      });
                    },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _isSaving ? null : _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                  ),
                ),
                child: Text(
                  _formatDate(_transactionDate),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              enabled: !_isSaving,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
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
                  : const Text('Save Expense'),
            ),
          ],
        ));
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _transactionDate = selectedDate;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_accountId == null || _categoryId == null) {
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
      final repository = ref.read(
        transactionRepositoryProvider,
      );

      await repository.createExpense(
        id: _generateTransactionId(),
        householdId: session.householdId,
        sourceAccountId: _accountId!,
        categoryId: _categoryId!,
        amount: int.parse(
          _amountController.text.trim(),
        ),
        expenseType: _expenseType,
        description: _normalizedDescription(),
        transactionDate: _transactionDate,
        userId: session.userId,
      );

      // Balance account berubah karena ledger transaction berubah.
      ref.invalidate(accountListProvider);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint('CREATE EXPENSE ERROR: $error');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to create expense.'),
        ),
      );

      setState(() {
        _isSaving = false;
      });
    }
  }
}

class _AccountOption {
  const _AccountOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class _CategoryOption {
  const _CategoryOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

String _expenseTypeLabel(ExpenseType type) {
  return switch (type) {
    ExpenseType.daily => 'Daily',
    ExpenseType.recurring => 'Recurring',
  };
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}

String? _normalizedDescription() {
  final description = _descriptionController.text.trim();

  if (description.isEmpty) {
    return null;
  }

  return description;
}

String _generateTransactionId() {
  return 'transaction-${DateTime.now().microsecondsSinceEpoch}';
}
