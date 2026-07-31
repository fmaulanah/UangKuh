import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../app/theme.dart';
import '../../../app/widgets/app_surface_card.dart';

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
        _errorMessage = context.l10n.unableToLoadAccounts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.transfer,
        ),
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
      return _TransferErrorState(
        message: _errorMessage!,
      );
    }

    if (_accounts.length < 2) {
      return const _TransferErrorState(
        message:
            'You need at least two active accounts before making a transfer.',
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.spaceMd,
          AppTheme.spaceSm,
          AppTheme.spaceMd,
          AppTheme.spaceXl,
        ),
        children: [
          //------------------------------------------------------------
          // Header
          //------------------------------------------------------------

          const _FormHeader(),

          const SizedBox(
            height: AppTheme.spaceLg,
          ),

          //------------------------------------------------------------
          // Amount
          //------------------------------------------------------------

          _AmountCard(
            controller: _amountController,
            enabled: !_isSaving,
          ),

          const SizedBox(
            height: AppTheme.spaceLg,
          ),

          //------------------------------------------------------------
          // Transfer Details
          //------------------------------------------------------------

          _FormSectionTitle(
            title: context.l10n.transferDetails,
            subtitle: context.l10n.transferDetailsSubtitle,
          ),

          const SizedBox(
            height: AppTheme.spaceSm,
          ),

          AppSurfaceCard(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _sourceAccountId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.fromAccount,
                    prefixIcon: Icon(
                      Icons.logout_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return context.l10n.selectSourceAccount;
                    }

                    return null;
                  },
                  items: _accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(
                            account.name,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                ),
                const SizedBox(
                  height: AppTheme.spaceMd,
                ),
                DropdownButtonFormField<String>(
                  value: _destinationAccountId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.toAccount,
                    prefixIcon: Icon(
                      Icons.login_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a destination account.';
                    }

                    if (value == _sourceAccountId) {
                      return 'Source and destination must be different.';
                    }

                    return null;
                  },
                  items: _accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(
                            account.name,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                ),
              ],
            ),
          ),

          const SizedBox(
            height: AppTheme.spaceLg,
          ),

          //------------------------------------------------------------
          // Additional Details
          //------------------------------------------------------------

          _FormSectionTitle(
            title: context.l10n.additionalDetails,
            subtitle: context.l10n.transferAdditionalDetailsSubtitle,
          ),

          const SizedBox(
            height: AppTheme.spaceSm,
          ),

          AppSurfaceCard(
            child: Column(
              children: [
                InkWell(
                  onTap: _isSaving ? null : _selectDate,
                  borderRadius: BorderRadius.circular(
                    AppTheme.radiusMd,
                  ),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                      ),
                      suffixIcon: Icon(
                        Icons.chevron_right_rounded,
                      ),
                    ),
                    child: Text(
                      _formatDate(
                        _transactionDate,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppTheme.spaceMd,
                ),
                TextFormField(
                  controller: _descriptionController,
                  enabled: !_isSaving,
                  minLines: 3,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Optional note',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        bottom: 48,
                      ),
                      child: Icon(
                        Icons.notes_rounded,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: AppTheme.spaceLg,
          ),

          //------------------------------------------------------------
          // Save
          //------------------------------------------------------------

          FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.swap_horiz_rounded,
                  ),
            label: Text(
              _isSaving ? 'Saving...' : context.l10n.saveTransfer,
            ),
          ),

          const SizedBox(
            height: AppTheme.spaceSm,
          ),

          Text(
            context.l10n.transferAdditionalDetailsSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
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

    final session = ref.read(
      appSessionProvider,
    );

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
        'CREATE TRANSFER ERROR: $error',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.unableToCreateTransfer,
          ),
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

// -----------------------------------------------------------------------------
// Header
// -----------------------------------------------------------------------------

class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(
              AppTheme.radiusLg,
            ),
          ),
          child: const Icon(
            Icons.swap_horiz_rounded,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(
          width: AppTheme.spaceMd,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.transferMoney,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: AppTheme.spaceXs,
              ),
              Text(
                context.l10n.transferMoneyDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Amount
// -----------------------------------------------------------------------------

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.controller,
    required this.enabled,
  });

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppTheme.spaceLg,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(
          alpha: 0.06,
        ),
        borderRadius: BorderRadius.circular(
          AppTheme.radiusXl,
        ),
        border: Border.all(
          color: AppTheme.primary.withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AMOUNT',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(
            height: AppTheme.spaceSm,
          ),
          TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
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
            decoration: const InputDecoration(
              hintText: '0',
              prefixText: 'Rp ',
              filled: false,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
          ),
          const SizedBox(
            height: AppTheme.spaceXs,
          ),
          Text(
            context.l10n.enterTransferAmount,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Section Title
// -----------------------------------------------------------------------------

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: AppTheme.spaceXs,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Error State
// -----------------------------------------------------------------------------

class _TransferErrorState extends StatelessWidget {
  const _TransferErrorState({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppTheme.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.danger.withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(
                  AppTheme.radiusXl,
                ),
              ),
              child: const Icon(
                Icons.swap_horizontal_circle_rounded,
                size: 30,
                color: AppTheme.danger,
              ),
            ),
            const SizedBox(
              height: AppTheme.spaceMd,
            ),
            Text(
              context.l10n.unableToLoadTransfer,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Options
// -----------------------------------------------------------------------------

class _AccountOption {
  const _AccountOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

String _formatDate(
  DateTime date,
) {
  final day = date.day.toString().padLeft(
        2,
        '0',
      );

  final month = date.month.toString().padLeft(
        2,
        '0',
      );

  return '$day/$month/${date.year}';
}
