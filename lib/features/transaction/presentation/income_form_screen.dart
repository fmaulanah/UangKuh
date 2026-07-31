import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../app/theme.dart';
import '../../../app/widgets/app_surface_card.dart';

import '../providers/transaction_repository_provider.dart';
import '../providers/transaction_history_provider.dart';

import '../../account/providers/account_list_provider.dart';
import '../../auth/providers/app_session_provider.dart';
import '../../category/domain/category_type.dart';
import '../../category/providers/category_repository_provider.dart';
import '../../dashboard/providers/dashboard_total_balance_provider.dart';

class IncomeFormScreen extends ConsumerStatefulWidget {
  const IncomeFormScreen({super.key});

  @override
  ConsumerState<IncomeFormScreen> createState() => _IncomeFormScreenState();
}

class _IncomeFormScreenState extends ConsumerState<IncomeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  String? _errorMessage;
  String? _accountId;
  String? _categoryId;

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
      final session = ref.read(
        appSessionProvider,
      );

      if (session == null) {
        throw StateError(
          'Session is not available.',
        );
      }

      final accountItems = await ref.read(
        accountListProvider.future,
      );

      final categoryRepository = ref.read(
        categoryRepositoryProvider,
      );

      final categories = await categoryRepository.getCategories(
        session.householdId,
        type: CategoryType.income,
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
      debugPrint(
        'INCOME OPTIONS ERROR: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = context.l10n.unableToLoadIncomeOptions;

        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.addIncome,
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
      return _IncomeErrorState(
        message: _errorMessage!,
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
          // ---------------------------------------------------------------
          // Header
          // ---------------------------------------------------------------

          const _FormHeader(),

          const SizedBox(
            height: AppTheme.spaceLg,
          ),

          // ---------------------------------------------------------------
          // Amount
          // ---------------------------------------------------------------

          _AmountCard(
            controller: _amountController,
            enabled: !_isSaving,
          ),

          const SizedBox(
            height: AppTheme.spaceLg,
          ),

          // ---------------------------------------------------------------
          // Income Details
          // ---------------------------------------------------------------

          _FormSectionTitle(
            title: context.l10n.incomeDetails,
            subtitle: context.l10n.incomeDetailsSubtitle,
          ),

          const SizedBox(
            height: AppTheme.spaceSm,
          ),

          AppSurfaceCard(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _accountId,
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Select an account.';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.toAccount,
                    prefixIcon: Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                  ),
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
                            _accountId = value;
                          });
                        },
                ),
                const SizedBox(
                  height: AppTheme.spaceMd,
                ),
                DropdownButtonFormField<String>(
                  value: _categoryId,
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Select an income category.';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.selectIncomeCategory,
                    prefixIcon: Icon(
                      Icons.category_outlined,
                    ),
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(
                            category.name,
                            overflow: TextOverflow.ellipsis,
                          ),
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
              ],
            ),
          ),

          const SizedBox(
            height: AppTheme.spaceLg,
          ),

          // ---------------------------------------------------------------
          // Additional Details
          // ---------------------------------------------------------------

          _FormSectionTitle(
            title: context.l10n.additionalDetails,
            subtitle: context.l10n.additionalDetailsSubtitle,
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
                  maxLines: 3,
                  minLines: 3,
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

          // ---------------------------------------------------------------
          // Save
          // ---------------------------------------------------------------

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
                    Icons.check_rounded,
                  ),
            label: Text(
              _isSaving ? 'Saving...' : context.l10n.saveIncome,
            ),
          ),

          const SizedBox(
            height: AppTheme.spaceSm,
          ),

          Text(
            context.l10n.incomeBalanceInformation,
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

    if (_accountId == null || _categoryId == null) {
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

      await repository.createIncome(
        id: _generateTransactionId(),
        householdId: session.householdId,
        destinationAccountId: _accountId!,
        categoryId: _categoryId!,
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
        'CREATE INCOME ERROR: $error',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.unableToCreateIncome,
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
            color: AppTheme.success.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(
              AppTheme.radiusLg,
            ),
          ),
          child: const Icon(
            Icons.arrow_downward_rounded,
            color: AppTheme.success,
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
                context.l10n.recordIncome,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: AppTheme.spaceXs,
              ),
              Text(
                context.l10n.recordIncomeDescription,
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
        color: AppTheme.success.withValues(
          alpha: 0.06,
        ),
        borderRadius: BorderRadius.circular(
          AppTheme.radiusXl,
        ),
        border: Border.all(
          color: AppTheme.success.withValues(
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
                  color: AppTheme.success,
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

              final amount = int.tryParse(
                text,
              );

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
            context.l10n.enterIncomeAmount,
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

class _IncomeErrorState extends StatelessWidget {
  const _IncomeErrorState({
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
                Icons.error_outline_rounded,
                size: 30,
                color: AppTheme.danger,
              ),
            ),
            const SizedBox(
              height: AppTheme.spaceMd,
            ),
            Text(
              context.l10n.unableToLoadForm,
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

class _CategoryOption {
  const _CategoryOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------

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

String _generateTransactionId() {
  return 'transaction-${DateTime.now().microsecondsSinceEpoch}';
}
