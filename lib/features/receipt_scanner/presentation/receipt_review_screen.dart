import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/widgets/app_surface_card.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/sync/sync_repository_provider.dart';

import '../../account/providers/account_list_provider.dart';
import '../../auth/providers/app_session_provider.dart';
import '../../category/domain/category_type.dart';
import '../../category/providers/category_repository_provider.dart';
import '../../dashboard/providers/dashboard_total_balance_provider.dart';
import '../../transaction/domain/expense_type.dart';
import '../../transaction/providers/transaction_history_provider.dart';
import '../../transaction/providers/transaction_repository_provider.dart';

import '../domain/receipt_draft.dart';
import '../domain/receipt_item.dart';

class ReceiptReviewScreen extends ConsumerStatefulWidget {
  const ReceiptReviewScreen({
    super.key,
    required this.draft,
  });

  final ReceiptDraft draft;

  @override
  ConsumerState<ReceiptReviewScreen> createState() =>
      _ReceiptReviewScreenState();
}

class _ReceiptReviewScreenState extends ConsumerState<ReceiptReviewScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  String? _accountId;
  String? _categoryId;

  final _merchantController = TextEditingController();
  final _totalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime _transactionDate = DateTime.now();
  List<ReceiptItem> _items = [];

  List<_AccountOption> _accounts = [];
  List<_CategoryOption> _categories = [];

  @override
  void initState() {
    super.initState();

    _merchantController.text = widget.draft.merchant ?? '';

    if (widget.draft.total != null) {
      _totalController.text = widget.draft.total.toString();
    }

    if (widget.draft.date != null) {
      _transactionDate = widget.draft.date!;
    }

    _items = List.of(widget.draft.items);

    Future.microtask(_loadOptions);
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    try {
      final session = ref.read(appSessionProvider);

      if (session == null) {
        throw StateError('Session is not available.');
      }

      final accountItems = await ref.read(accountListProvider.future);

      final categoryRepository = ref.read(categoryRepositoryProvider);
      final categories = await categoryRepository.getCategories(
        session.householdId,
        type: CategoryType.expense,
      );

      if (!mounted) return;

      final accounts = accountItems
          .map((item) => _AccountOption(
                id: item.account.id,
                name: item.account.name,
              ))
          .toList();

      final categoryOptions = categories
          .map((category) => _CategoryOption(
                id: category.id,
                name: category.name,
              ))
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
      debugPrint('RECEIPT REVIEW OPTIONS ERROR: $error');

      if (!mounted) return;

      setState(() {
        _errorMessage = context.l10n.unableToLoadExpenseOptions;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Receipt'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.danger.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 30,
                  color: AppTheme.danger,
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              Text(
                context.l10n.unableToLoadForm,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spaceSm),
              Text(
                _errorMessage!,
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
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.danger.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppTheme.danger,
                ),
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review Receipt',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppTheme.spaceXs),
                    Text(
                      'Verify and edit the scanned data before saving.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spaceLg),

          // Amount
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            decoration: BoxDecoration(
              color: AppTheme.danger.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
              border: Border.all(
                color: AppTheme.danger.withValues(alpha: 0.14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.danger,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                ),
                const SizedBox(height: AppTheme.spaceSm),
                TextFormField(
                  controller: _totalController,
                  enabled: !_isSaving,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Amount is required.';
                    final amount = int.tryParse(text);
                    if (amount == null) return 'Enter a valid amount.';
                    if (amount <= 0) return 'Amount must be greater than zero.';
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
                if (widget.draft.total == null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppTheme.spaceXs),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppTheme.warning,
                        ),
                        const SizedBox(width: AppTheme.spaceXs),
                        Expanded(
                          child: Text(
                            'Total not detected. Please enter manually.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppTheme.warning),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          // Merchant & Date
          _SectionTitle(
            title: 'Receipt Details',
            subtitle: 'Merchant and date from the receipt.',
          ),
          const SizedBox(height: AppTheme.spaceSm),
          AppSurfaceCard(
            child: Column(
              children: [
                TextFormField(
                  controller: _merchantController,
                  enabled: !_isSaving,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Merchant',
                    hintText: 'e.g. Indomaret',
                    prefixIcon: Icon(Icons.store_outlined),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceMd),
                InkWell(
                  onTap: _isSaving ? null : _selectDate,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      suffixIcon: Icon(Icons.chevron_right_rounded),
                    ),
                    child: Text(_formatDate(_transactionDate)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          // Items
          if (_items.isNotEmpty) ...[
            _SectionTitle(
              title: 'Items',
              subtitle: '${_items.length} item(s) detected.',
            ),
            const SizedBox(height: AppTheme.spaceSm),
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < _items.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spaceMd,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              _items[i].name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              '${_items[i].quantity ?? 1}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              _items[i].amount != null
                                  ? _formatRupiah(_items[i].amount!)
                                  : '-',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < _items.length - 1) const Divider(height: 1),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
          ],

          // Account & Category
          _SectionTitle(
            title: context.l10n.expenseDetails,
            subtitle: context.l10n.expenseDetailsSubtitle,
          ),
          const SizedBox(height: AppTheme.spaceSm),
          AppSurfaceCard(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _accountId,
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) return 'Select an account.';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.fromAccount,
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                  ),
                  items: _accounts
                      .map((account) => DropdownMenuItem(
                            value: account.id,
                            child: Text(
                              account.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          setState(() {
                            _accountId = value;
                          });
                        },
                ),
                const SizedBox(height: AppTheme.spaceMd),
                DropdownButtonFormField<String>(
                  value: _categoryId,
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) return 'Select an expense category.';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.selectExpenseCategory,
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(
                              category.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
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

          const SizedBox(height: AppTheme.spaceLg),

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
                : const Icon(Icons.check_rounded),
            label: Text(
              _isSaving ? 'Saving...' : context.l10n.saveExpense,
            ),
          ),

          const SizedBox(height: AppTheme.spaceSm),

          Text(
            context.l10n.expenseBalanceInformation,
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

    if (selectedDate == null || !mounted) return;

    setState(() {
      _transactionDate = selectedDate;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_accountId == null || _categoryId == null) return;

    final session = ref.read(appSessionProvider);
    if (session == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(transactionRepositoryProvider);

      final description = _merchantController.text.trim().isNotEmpty
          ? _merchantController.text.trim()
          : null;

      await repository.createExpense(
        id: 'transaction-${DateTime.now().microsecondsSinceEpoch}',
        householdId: session.householdId,
        sourceAccountId: _accountId!,
        categoryId: _categoryId!,
        amount: int.parse(_totalController.text.trim()),
        expenseType: ExpenseType.daily,
        description: description,
        transactionDate: _transactionDate,
        userId: session.userId,
      );

      await ref.read(syncRepositoryProvider).uploadPendingTransactions();

      ref.invalidate(accountListProvider);
      ref.invalidate(transactionHistoryProvider);
      ref.invalidate(dashboardTotalBalanceProvider);

      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      debugPrint('RECEIPT SAVE ERROR: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.unableToCreateExpense),
        ),
      );

      setState(() {
        _isSaving = false;
      });
    }
  }
}

// ---------------------------------------------------------------------------
// Section Title
// ---------------------------------------------------------------------------
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
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
        const SizedBox(height: AppTheme.spaceXs),
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

// ---------------------------------------------------------------------------
// Options
// ---------------------------------------------------------------------------
class _AccountOption {
  const _AccountOption({required this.id, required this.name});
  final String id;
  final String name;
}

class _CategoryOption {
  const _CategoryOption({required this.id, required this.name});
  final String id;
  final String name;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String _formatRupiah(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final positionFromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }
  return 'Rp ${buffer.toString()}';
}
