import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../app/theme.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../auth/providers/app_session_provider.dart';

import '../domain/account_purpose.dart';
import '../domain/account_type.dart';
import '../providers/account_list_provider.dart';
import '../providers/account_repository_provider.dart';

import 'account_list_item.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.accounts),
        actions: [
          IconButton(
            tooltip: 'Add account',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              context.push('/me/accounts/new');
            },
          ),
        ],
      ),
      body: accountsAsync.when(
        loading: () => const _AccountLoadingState(),
        error: (error, stackTrace) => _AccountError(
          onRetry: () {
            ref.invalidate(accountListProvider);
          },
        ),
        data: (accounts) {
          if (accounts.isEmpty) {
            return _EmptyAccounts(
              onAdd: () {
                context.push('/accounts/new');
              },
            );
          }

          final totalBalance = accounts.fold<int>(
            0,
            (total, item) => total + item.currentBalance,
          );

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async {
              ref.invalidate(accountListProvider);

              await ref.read(accountListProvider.future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spaceMd,
                AppTheme.spaceMd,
                AppTheme.spaceMd,
                AppTheme.spaceLg,
              ),
              children: [
                const _AccountHeader(),
                const SizedBox(
                  height: AppTheme.spaceMd,
                ),
                _TotalBalanceCard(
                  totalBalance: totalBalance,
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.yourAccounts,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: AppTheme.spaceXs,
                ),
                Text(
                  '${accounts.length} account${accounts.length > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                ...accounts.map(
                  (item) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppTheme.spaceSm,
                      ),
                      child: _AccountCard(
                        item: item,
                        onTap: () {
                          context.push(
                            '/me/accounts/${item.account.id}/edit',
                          );
                        },
                        onArchive: () {
                          _archiveAccount(
                            context,
                            ref,
                            item,
                          );
                        },
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _archiveAccount(
    BuildContext context,
    WidgetRef ref,
    AccountListItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Archive "${item.account.name}"?\n\nThis account will be hidden from your active accounts, but its transaction history will remain available.'),
          content: Text(
            'Archive "${item.account.name}"? '
            'The account will be hidden from your active accounts.',
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
              child: const Text('Archive'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final session = ref.read(appSessionProvider);

    if (session == null) {
      return;
    }

    try {
      final repository = ref.read(accountRepositoryProvider);

      await repository.archiveAccount(
        id: item.account.id,
        userId: session.userId,
      );

      ref.invalidate(accountListProvider);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.unableToArchiveAccount),
        ),
      );
    }
  }
}

class _TotalBalanceCard extends StatelessWidget {
  const _TotalBalanceCard({
    required this.totalBalance,
  });

  final int totalBalance;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(
          AppTheme.spaceLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.totalBalance,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              formatRupiah(totalBalance),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            Text(
              context.l10n.acrossAllActiveAccounts,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.item,
    required this.onTap,
    required this.onArchive,
  });

  final AccountListItem item;
  final VoidCallback onTap;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final account = item.account;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppTheme.radiusLg,
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(
            AppTheme.spaceMd,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primary.withValues(
                  alpha: 0.12,
                ),
                foregroundColor: AppTheme.primary,
                child: Icon(
                  _accountIcon(account.type),
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
                      account.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: AppTheme.spaceXs,
                    ),
                    Text(
                      '${_accountTypeLabel(account.type)} • ${_accountPurposeLabel(account.purpose)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: AppTheme.spaceMd,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatRupiah(
                      item.currentBalance,
                    ),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'More',
                    icon: const Icon(
                      Icons.more_vert_rounded,
                    ),
                    onSelected: (value) {
                      if (value == 'archive') {
                        onArchive();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            Icon(Icons.archive_outlined),
                            SizedBox(width: 12),
                            Text('Archive'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAccounts extends StatelessWidget {
  const _EmptyAccounts({
    required this.onAdd,
  });

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(
              height: AppTheme.spaceMd,
            ),
            Text(
              context.l10n.noAccountsYet,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            Text(
              'Create your first account to start managing your finances.',
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

class _AccountError extends StatelessWidget {
  const _AccountError({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppTheme.danger,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.unableToLoadAccounts,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: AppTheme.spaceSm,
            ),
            Text(
              'Please try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
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

class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.accounts,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: AppTheme.spaceXs,
        ),
        Text(
          context.l10n.manageAccounts,
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
      child: Padding(
        padding: EdgeInsets.all(
          AppTheme.spaceLg,
        ),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

IconData _accountIcon(AccountType type) {
  return switch (type) {
    AccountType.bank => Icons.account_balance_outlined,
    AccountType.eWallet => Icons.account_balance_wallet_outlined,
    AccountType.cash => Icons.payments_outlined,
    AccountType.saving => Icons.savings_outlined,
    AccountType.investment => Icons.trending_up,
  };
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
