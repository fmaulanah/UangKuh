import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/sync/sync_repository_provider.dart';
import '../../../app/theme.dart';

import '../../auth/providers/app_session_provider.dart';

import '../domain/account_purpose.dart';
import '../domain/account_type.dart';
import '../providers/account_list_provider.dart';
import '../providers/account_repository_provider.dart';

class AccountFormScreen extends ConsumerStatefulWidget {
  const AccountFormScreen({
    this.accountId,
    super.key,
  });

  final String? accountId;

  bool get isEditing => accountId != null;

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController();

  AccountType _type = AccountType.bank;
  AccountPurpose _purpose = AccountPurpose.spending;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      _isLoading = true;
      Future.microtask(_loadAccount);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.editAccount),
        ),
        body: const _AccountLoadingState(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.account,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spaceMd,
              AppTheme.spaceMd,
              AppTheme.spaceMd,
              AppTheme.spaceLg,
            ),
            children: [
              _AccountHeader(
                isEditing: widget.isEditing,
              ),
              const SizedBox(
                height: AppTheme.spaceMd,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(
                    AppTheme.spaceMd,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        enabled: !_isSaving,
                        decoration: InputDecoration(
                          labelText: context.l10n.accountName,
                          hintText: 'e.g. BCA, GoPay, Cash',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.l10n.accountNameRequired;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<AccountType>(
                        value: _type,
                        decoration: InputDecoration(
                          labelText: context.l10n.accountType,
                          border: OutlineInputBorder(),
                        ),
                        items: AccountType.values
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(_accountTypeLabel(type)),
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
                                  _type = value;
                                });
                              },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<AccountPurpose>(
                        value: _purpose,
                        decoration: InputDecoration(
                          labelText: context.l10n.purpose,
                          border: OutlineInputBorder(),
                        ),
                        items: AccountPurpose.values
                            .map(
                              (purpose) => DropdownMenuItem(
                                value: purpose,
                                child: Text(
                                  _accountPurposeLabel(purpose),
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
                                  _purpose = value;
                                });
                              },
                      ),
                      if (!widget.isEditing) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _initialBalanceController,
                          keyboardType: TextInputType.number,
                          enabled: !_isSaving,
                          decoration: InputDecoration(
                            labelText: context.l10n.initialBalance,
                            hintText: '0',
                            prefixText: 'Rp ',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';

                            if (text.isEmpty) {
                              return null;
                            }

                            final amount = int.tryParse(text);

                            if (amount == null) {
                              return context.l10n.enterValidAmount;
                            }

                            if (amount < 0) {
                              return context
                                  .l10n.initialBalanceCannotBeNegative;
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.initialBalanceDescription,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(
                        height: AppTheme.spaceLg,
                      ),
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
                                    ? context.l10n.saveChanges
                                    : context.l10n.saveAccount,
                              ),
                      ),
                    ],
                  ),
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
      final repository = ref.read(accountRepositoryProvider);

      if (widget.isEditing) {
        await repository.updateAccount(
          id: widget.accountId!,
          name: _nameController.text,
          type: _type,
          purpose: _purpose,
          userId: session.userId,
        );
      } else {
        final initialBalance =
            int.tryParse(_initialBalanceController.text.trim()) ?? 0;

        await repository.createAccount(
          id: _generateId(),
          householdId: session.householdId,
          name: _nameController.text,
          type: _type,
          purpose: _purpose,
          initialBalance: initialBalance,
          userId: session.userId,
        );
      }

      await ref.read(syncRepositoryProvider).uploadAccounts();

      ref.invalidate(accountListProvider);

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
                ? 'Unable to update account.'
                : 'Unable to create account.',
          ),
        ),
      );

      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _loadAccount() async {
    try {
      final repository = ref.read(accountRepositoryProvider);

      final account = await repository.getAccountById(
        widget.accountId!,
      );

      if (!mounted) {
        return;
      }

      if (account == null) {
        Navigator.of(context).pop();
        return;
      }

      _nameController.text = account.name;

      setState(() {
        _type = account.type;
        _purpose = account.purpose;
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
    return 'account-${DateTime.now().microsecondsSinceEpoch}';
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    required this.isEditing,
  });

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? context.l10n.editAccount : context.l10n.createAccount,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: AppTheme.spaceXs,
        ),
        Text(
          isEditing
              ? 'Update your account information.'
              : 'Create a new account to manage your money.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _AccountLoadingState extends StatelessWidget {
  const _AccountLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

String _accountTypeLabel(AccountType type) {
  return switch (type) {
    AccountType.bank => 'Bank',
    AccountType.eWallet => 'E-Wallet',
    AccountType.cash => 'Cash',
    AccountType.saving => 'Saving',
    AccountType.investment => 'Investment',
  };
}

String _accountPurposeLabel(AccountPurpose purpose) {
  return switch (purpose) {
    AccountPurpose.spending => 'Spending',
    AccountPurpose.saving => 'Saving',
    AccountPurpose.investment => 'Investment',
  };
}
