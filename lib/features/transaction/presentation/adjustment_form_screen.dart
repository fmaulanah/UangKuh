import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/app_session_provider.dart';
import '../../dashboard/providers/dashboard_total_balance_provider.dart';
import '../providers/transaction_history_provider.dart';
import '../providers/transaction_repository_provider.dart';

import '../../account/presentation/account_list_item.dart';
import '../../account/providers/account_list_provider.dart';

class AdjustmentFormScreen extends ConsumerStatefulWidget {
  const AdjustmentFormScreen({
    super.key,
  });

  @override
  ConsumerState<AdjustmentFormScreen> createState() {
    return _AdjustmentFormScreenState();
  }
}

class _AdjustmentFormScreenState extends ConsumerState<AdjustmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _accountId;
  DateTime _transactionDate = DateTime.now();

  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountListAsync = ref.watch(
      accountListProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Adjustment',
        ),
      ),
      body: accountListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Unable to load accounts.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (accountItems) {
          return _buildForm(
            accountItems,
          );
        },
      ),
    );
  }

  Widget _buildForm(
    List<AccountListItem> accountItems,
  ) {
    if (accountItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Create an account before making an adjustment.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _accountId,
            decoration: const InputDecoration(
              labelText: 'Account',
            ),
            items: accountItems.map(
              (item) {
                return DropdownMenuItem<String>(
                  value: item.account.id,
                  child: Text(
                    item.account.name,
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                _accountId = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Select an account.';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Adjustment amount',
              hintText: 'Example: 100000 or -100000',
              prefixText: 'Rp ',
            ),
            validator: (value) {
              final amount = int.tryParse(
                value?.trim() ?? '',
              );

              if (amount == null) {
                return 'Enter a valid amount.';
              }

              if (amount == 0) {
                return 'Adjustment cannot be zero.';
              }

              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Use a positive amount to increase the balance '
            'or a negative amount to decrease it.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Transaction date',
            ),
            subtitle: Text(
              _formatDate(
                _transactionDate,
              ),
            ),
            trailing: const Icon(
              Icons.calendar_today_outlined,
            ),
            onTap: _selectDate,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLength: 200,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Optional',
              alignLabelWithHint: true,
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
                : const Text(
                    'Save Adjustment',
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2000),
      lastDate: now,
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

    if (_accountId == null) {
      return;
    }

    final session = ref.read(
      appSessionProvider,
    );

    if (session == null) {
      return;
    }

    final amount = int.parse(
      _amountController.text.trim(),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(
        transactionRepositoryProvider,
      );

      await repository.createAdjustment(
        id: _generateTransactionId(),
        householdId: session.householdId,
        accountId: _accountId!,
        amount: amount,
        description: _normalizedDescription(),
        transactionDate: _transactionDate,
        userId: session.userId,
      );

      ref.invalidate(
        accountListProvider,
      );

      ref.invalidate(
        transactionHistoryProvider,
      );

      ref.invalidate(
        dashboardTotalBalanceProvider,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(
        'CREATE ADJUSTMENT ERROR: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to create adjustment.',
          ),
        ),
      );
    }
  }

  String? _normalizedDescription() {
    final description = _descriptionController.text.trim();

    if (description.isEmpty) {
      return null;
    }

    return description;
  }
}

String _generateTransactionId() {
  return 'transaction-${DateTime.now().microsecondsSinceEpoch}';
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}
