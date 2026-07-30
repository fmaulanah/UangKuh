import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_repository_provider.dart';
import '../providers/transaction_history_provider.dart';

import '../../account/providers/account_list_provider.dart';
import '../../auth/providers/app_session_provider.dart';
import '../../dashboard/providers/dashboard_total_balance_provider.dart';

class TransferFormScreen extends ConsumerStatefulWidget {
  const TransferFormScreen({super.key});

  @override
  ConsumerState<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends ConsumerState<TransferFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  String? _errorMessage;
  String? _sourceAccountId;
  String? _destinationAccountId;

  DateTime _transactionDate = DateTime.now();

  List<_AccountOption> _accounts = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadAccounts);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAccounts() async {
    try {
      final session = ref.read(appSessionProvider);

      if (session == null) {
        throw StateError('Session is not available.');
      }

      final accountItems = await ref.read(
        accountListProvider.future,
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

      setState(() {
        _accounts = accounts;

        if (accounts.isNotEmpty) {
          _sourceAccountId = accounts.first.id;
        }

        if (accounts.length >= 2) {
          _destinationAccountId = accounts[1].id;
        }

        _isLoading = false;
      });
    } catch (error) {
      debugPrint('TRANSFER ACCOUNTS ERROR: $error');

      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Unable to load accounts.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text('Transfer'),
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
        child: Text(_errorMessage!),
      );
    }

    if (_accounts.length < 2) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'You need at least two active accounts to make a transfer.',
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
          TextFormField(
            controller: _amountController,
            enabled: !_isSaving,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: '0',
              prefixText: 'Rp ',
              border: OutlineInputBorder(),
            ),
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
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _sourceAccountId,
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
                      _sourceAccountId = value;
                    });
                  },
            validator: (value) {
              if (value == null) {
                return 'Select a source account.';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _destinationAccountId,
            decoration: const InputDecoration(
              labelText: 'To account',
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
                      _destinationAccountId = value;
                    });
                  },
            validator: (value) {
              if (value == null) {
                return 'Select a destination account.';
              }

              if (value == _sourceAccountId) {
                return 'Source and destination must be different.';
              }

              return null;
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
            enabled: !_isSaving,
            maxLines: 3,
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
                : const Text('Save Transfer'),
          ),
        ],
      ),
    );
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

    if (_sourceAccountId == null || _destinationAccountId == null) {
      return;
    }

    if (_sourceAccountId == _destinationAccountId) {
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

      await repository.createTransfer(
        id: _generateTransactionId(),
        householdId: session.householdId,
        sourceAccountId: _sourceAccountId!,
        destinationAccountId: _destinationAccountId!,
        amount: int.parse(
          _amountController.text.trim(),
        ),
        description: _normalizedDescription(),
        transactionDate: _transactionDate,
        userId: session.userId,
      );

      ref.invalidate(accountListProvider);
      ref.invalidate(transactionHistoryProvider);
      ref.invalidate(dashboardTotalBalanceProvider);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint('CREATE TRANSFER ERROR: $error');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to create transfer.'),
        ),
      );

      setState(() {
        _isSaving = false;
      });
    }
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
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}

class _AccountOption {
  const _AccountOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}
