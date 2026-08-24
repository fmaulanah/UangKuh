import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/sync/sync_repository_provider.dart';

import '../providers/recurring_plan_provider.dart';
import '../providers/recurring_repository_provider.dart';
import '../../account/providers/account_list_provider.dart';
import '../../auth/providers/app_session_provider.dart';
import '../../transaction/providers/transaction_history_provider.dart';

class RecurringPaymentScreen extends ConsumerStatefulWidget {
  const RecurringPaymentScreen({
    required this.recurringId,
    super.key,
  });

  final String recurringId;

  @override
  ConsumerState<RecurringPaymentScreen> createState() =>
      _RecurringPaymentScreenState();
}

class _RecurringPaymentScreenState
    extends ConsumerState<RecurringPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  DateTime _transactionDate = DateTime.now();

  String? _selectedAccountId;

  bool _isLoading = true;
  bool _isSaving = false;

  Object? _loadError;

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadRecurring);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadRecurring() async {
    try {
      final repository = ref.read(
        recurringRepositoryProvider,
      );

      final recurring = await repository.getRecurringExpenseById(
        widget.recurringId,
      );

      if (recurring == null) {
        throw StateError(
          'Recurring expense not found.',
        );
      }

      if (!mounted) {
        return;
      }

      _amountController.text = recurring.defaultAmount.toString();

      setState(() {
        _selectedAccountId = recurring.defaultAccountId;

        _isLoading = false;
      });

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      debugPrint(
        'LOAD RECURRING PAYMENT ERROR: $error',
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

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(
      accountListProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay Recurring Expense'),
      ),
      body: _isLoading
          ? const _RecurringPaymentLoadingState()
          : _loadError != null
              ? const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24), child: Text("Error.")),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      AppTheme.spaceMd,
                      AppTheme.spaceMd,
                      AppTheme.spaceMd,
                      AppTheme.spaceLg,
                    ),
                    children: [
                      const _RecurringPaymentHeader(),
                      const SizedBox(
                        height: AppTheme.spaceLg,
                      ),
                      Text(
                        'Payment Information',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(
                        height: AppTheme.spaceMd,
                      ),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          hintText: '0',
                          prefixText: 'Rp ',
                        ),
                        textInputAction: TextInputAction.next,
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
                      const SizedBox(
                        height: AppTheme.spaceLg,
                      ),
                      accountsAsync.when(
                        loading: () => DropdownButtonFormField<String>(
                          items: const [],
                          onChanged: null,
                          decoration: const InputDecoration(
                            labelText: 'Account',
                            hintText: 'Loading accounts...',
                          ),
                        ),
                        error: (error, stackTrace) =>
                            DropdownButtonFormField<String>(
                          items: const [],
                          onChanged: null,
                          decoration: const InputDecoration(
                            labelText: 'Account',
                            hintText: 'Unable to load accounts',
                          ),
                        ),
                        data: (accountItems) {
                          return DropdownButtonFormField<String>(
                            value: _selectedAccountId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Account',
                              hintText: 'Choose payment account',
                            ),
                            items: accountItems
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item.account.id,
                                    child: Text(
                                      item.account.name,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedAccountId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Account is required.';
                              }

                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(
                            AppTheme.spaceMd,
                            AppTheme.spaceMd,
                            AppTheme.spaceMd,
                            AppTheme.spaceLg,
                          ),
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
                          onTap: _selectTransactionDate,
                        ),
                      ),
                      const SizedBox(
                        height: AppTheme.spaceLg,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isSaving ? null : _pay,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Confirm Payment',
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> _selectTransactionDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2020),
      lastDate: now,
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _transactionDate = selectedDate;
    });
  }

  Future<void> _pay() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final accountId = _selectedAccountId;

    if (accountId == null) {
      return;
    }

    final session = ref.read(appSessionProvider);

    if (session == null) {
      return;
    }

    final now = DateTime.now();

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(
        recurringRepositoryProvider,
      );

      await repository.payRecurringExpense(
        paymentId: _generateRecurringPaymentId(),
        transactionId: _generateRecurringTransactionId(),
        recurringExpenseId: widget.recurringId,
        householdId: session.householdId,
        sourceAccountId: accountId,
        amount: int.parse(
          _amountController.text.trim(),
        ),
        periodYear: now.year,
        periodMonth: now.month,
        transactionDate: _transactionDate,
        userId: session.userId,
      );

      await ref.read(syncRepositoryProvider).uploadRecurringPayments();

      // Payment status berubah.
      ref.invalidate(recurringPlanProvider);

      // Ledger berubah.
      ref.invalidate(accountListProvider);

      // History berubah.
      ref.invalidate(transactionHistoryProvider);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(
        'PAY RECURRING EXPENSE ERROR: $error',
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
            'Unable to pay recurring expense.',
          ),
        ),
      );
    }
  }
}

class _RecurringPaymentHeader extends StatelessWidget {
  const _RecurringPaymentHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pay Recurring Expense',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: AppTheme.spaceXs,
        ),
        Text(
          'Record a payment for this recurring expense.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _RecurringPaymentLoadingState extends StatelessWidget {
  const _RecurringPaymentLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(
          AppTheme.spaceLg,
        ),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String _generateRecurringPaymentId() {
  return 'recurring-payment-${DateTime.now().microsecondsSinceEpoch}';
}

String _generateRecurringTransactionId() {
  return 'transaction-${DateTime.now().microsecondsSinceEpoch}';
}
