import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';

import '../../../app/theme.dart';
import '../../../app/widgets/app_surface_card.dart';

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
        title: Text(
          context.l10n.addAdjustment,
        ),
      ),
      body: accountListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const _AdjustmentErrorState(),
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
      return const _EmptyAccountState();
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
          // Account
          // ---------------------------------------------------------------

          _FormSectionTitle(
            title: context.l10n.accounts,
            subtitle: 'Choose the balance you want to correct.',
          ),

          const SizedBox(
            height: AppTheme.spaceSm,
          ),

          AppSurfaceCard(
            child: DropdownButtonFormField<String>(
              value: _accountId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.l10n.selectAccount,
                prefixIcon: Icon(
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              items: accountItems.map(
                (item) {
                  return DropdownMenuItem<String>(
                    value: item.account.id,
                    child: Text(
                      item.account.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ).toList(),
              onChanged: _isSaving
                  ? null
                  : (value) {
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
          ),

          const SizedBox(
            height: AppTheme.spaceLg,
          ),

          // ---------------------------------------------------------------
          // Adjustment Guide
          // ---------------------------------------------------------------

          _FormSectionTitle(
            title: context.l10n.balanceCorrection,
            subtitle: context.l10n.balanceCorrectionSubtitle,
          ),

          const SizedBox(
            height: AppTheme.spaceSm,
          ),

          const _AdjustmentGuide(),

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
                  maxLength: 200,
                  maxLines: 3,
                  minLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Example: Balance correction',
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
              _isSaving ? 'Saving...' : context.l10n.saveAdjustment,
            ),
          ),

          const SizedBox(
            height: AppTheme.spaceSm,
          ),

          Text(
            context.l10n.adjustmentAdditionalDetailsSubtitle,
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
        SnackBar(
          content: Text(
            context.l10n.unableToCreateAdjustment,
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

// -----------------------------------------------------------------------------
// Header
// -----------------------------------------------------------------------------

class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primary.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(
              AppTheme.radiusLg,
            ),
          ),
          child: Icon(
            Icons.tune_rounded,
            color: primary,
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
                context.l10n.correctBalance,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: AppTheme.spaceXs,
              ),
              Text(
                context.l10n.correctBalanceDescription,
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
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppTheme.spaceLg,
      ),
      decoration: BoxDecoration(
        color: primary.withValues(
          alpha: 0.06,
        ),
        borderRadius: BorderRadius.circular(
          AppTheme.radiusXl,
        ),
        border: Border.all(
          color: primary.withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adjustmentAmount,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: primary,
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
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
            ),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
            validator: (value) {
              final text = value?.trim() ?? '';

              if (text.isEmpty) {
                return 'Adjustment amount is required.';
              }

              final amount = int.tryParse(
                text,
              );

              if (amount == null) {
                return 'Enter a valid amount.';
              }

              if (amount == 0) {
                return 'Adjustment cannot be zero.';
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
            context.l10n.adjustmentAmountHint,
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
// Adjustment Guide
// -----------------------------------------------------------------------------

class _AdjustmentGuide extends StatelessWidget {
  const _AdjustmentGuide();

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: _AdjustmentGuideItem(
              icon: Icons.add_rounded,
              title: context.l10n.increase,
              example: '+100000',
              description: context.l10n.addToBalance,
              color: AppTheme.success,
            ),
          ),
          Container(
            width: 1,
            height: 72,
            color: AppTheme.border,
          ),
          Expanded(
            child: _AdjustmentGuideItem(
              icon: Icons.remove_rounded,
              title: context.l10n.decrease,
              example: '-100000',
              description: context.l10n.reduceBalance,
              color: AppTheme.danger,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdjustmentGuideItem extends StatelessWidget {
  const _AdjustmentGuideItem({
    required this.icon,
    required this.title,
    required this.example,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String example;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTheme.radiusSm,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
              ),
              const SizedBox(
                width: AppTheme.spaceSm,
              ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppTheme.spaceSm,
          ),
          Text(
            example,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            description,
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
// Error / Empty State
// -----------------------------------------------------------------------------

class _AdjustmentErrorState extends StatelessWidget {
  const _AdjustmentErrorState();

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
              context.l10n.unableToLoadAccounts,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            Text(
              'We could not load your accounts for this adjustment.',
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

class _EmptyAccountState extends StatelessWidget {
  const _EmptyAccountState();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

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
                color: primary.withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(
                  AppTheme.radiusXl,
                ),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 30,
                color: primary,
              ),
            ),
            const SizedBox(
              height: AppTheme.spaceMd,
            ),
            Text(
              'No account available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            Text(
              'Create an account before making an adjustment.',
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
// Helpers
// -----------------------------------------------------------------------------

String _generateTransactionId() {
  return 'transaction-${DateTime.now().microsecondsSinceEpoch}';
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
