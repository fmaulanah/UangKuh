import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency_formatter.dart';
import '../domain/account_purpose.dart';
import '../domain/account_type.dart';
import '../providers/account_list_provider.dart';
import 'account_list_item.dart';

import '../../auth/providers/app_session_provider.dart';
import '../providers/account_repository_provider.dart';

import 'package:go_router/go_router.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            tooltip: 'Add account',
            onPressed: () {
              context.push('/me/accounts/new');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: accountsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
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
            onRefresh: () async {
              ref.invalidate(accountListProvider);

              await ref.read(accountListProvider.future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _TotalBalanceCard(
                  totalBalance: totalBalance,
                ),
                const SizedBox(height: 24),
                Text(
                  'Your accounts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...accounts.map(
                  (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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
          title: const Text('Archive account?'),
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
        const SnackBar(
          content: Text('Unable to archive account.'),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total balance',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              formatRupiah(totalBalance),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
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
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          child: Icon(_accountIcon(account.type)),
        ),
        title: Text(account.name),
        subtitle: Text(
          '${_accountTypeLabel(account.type)} • '
          '${_accountPurposeLabel(account.purpose)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatRupiah(item.currentBalance),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            PopupMenuButton<String>(
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
            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              'No accounts yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first account to start tracking your money.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // FilledButton.icon(
            //   onPressed: onAdd,
            //   icon: const Icon(Icons.add),
            //   label: const Text('Add Account'),
            // ),
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
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load accounts.',
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
