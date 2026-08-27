import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';
import '../../auth/providers/auth_controller.dart';
import '../../household/providers/household_profile_provider.dart';
import '../../../core/sync/sync_repository_provider.dart';
import '../../../core/sync/sync_state_provider.dart';
import '../../../app/widgets/app_surface_card.dart';
import '../../../app/theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final syncState = ref.watch(syncStateProvider);
    final isSyncing = syncState.status == SyncStateStatus.syncing;
    final householdProfileAsync = ref.watch(householdProfileProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Me',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        householdProfileAsync.when(
          loading: () => const AppSurfaceCard(
            child: SizedBox(
              height: 48,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (household) {
            if (household == null) return const SizedBox.shrink();

            return AppSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        child: Icon(
                          Icons.home_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Household',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                            Text(
                              household.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (household.isOwner && household.inviteCode != null) ...[
                    const Divider(height: 24),
                    Text(
                      'Invite Code',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            household.inviteCode!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: household.inviteCode!),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invite code copied'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text('Copy'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(
            Icons.account_balance_wallet_outlined,
          ),
          title: const Text('Accounts'),
          subtitle: const Text('Manage your financial accounts'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.push('/me/accounts');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.category_outlined,
          ),
          title: const Text('Categories'),
          subtitle: const Text('Manage income and expense categories'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.push('/me/categories');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.language,
          ),
          title: const Text('Language'),
          subtitle: const Text('English / Bahasa Indonesia'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showLanguageDialog(
              context,
              ref,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.sync,
          ),
          title: const Text('Sync Now'),
          subtitle: const Text('Upload and refresh your data'),
          trailing: isSyncing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.chevron_right),
          onTap: isSyncing ? null : _syncNow,
        ),
        if (syncState.status == SyncStateStatus.success)
          ListTile(
            leading: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            title: const Text('Sync successful'),
            subtitle: Text(
              'Last sync: ${_formatSyncTime(syncState.lastSuccessfulSync)}',
            ),
          ),
        if (syncState.status == SyncStateStatus.error)
          ListTile(
            leading: const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            title: const Text('Sync failed'),
            subtitle: Text(syncState.errorMessage ?? 'Unknown sync error.'),
          ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.logout_rounded,
            color: Colors.red,
          ),
          title: const Text('Logout'),
          subtitle: const Text('Sign out from this device'),
          textColor: Colors.red,
          iconColor: Colors.red,
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: const Text('Logout'),
                  content: const Text(
                    'Are you sure you want to logout?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('Logout'),
                    ),
                  ],
                );
              },
            );

            if (confirm != true || !context.mounted) {
              return;
            }

            await ref.read(authControllerProvider).signOut();
          },
        ),
      ],
    );
  }

  Future<void> _syncNow() async {
    final currentState = ref.read(syncStateProvider);

    if (currentState.status == SyncStateStatus.syncing) {
      return;
    }

    ref.read(syncStateProvider.notifier).state = SyncState(
      status: SyncStateStatus.syncing,
      lastSuccessfulSync: currentState.lastSuccessfulSync,
    );

    try {
      await ref.read(syncRepositoryProvider).syncAll();

      final syncedAt = DateTime.now();

      ref.read(syncStateProvider.notifier).state = SyncState(
        status: SyncStateStatus.success,
        lastSuccessfulSync: syncedAt,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sync completed successfully.'),
        ),
      );
    } catch (error) {
      ref.read(syncStateProvider.notifier).state = SyncState(
        status: SyncStateStatus.error,
        lastSuccessfulSync: currentState.lastSuccessfulSync,
        errorMessage: error.toString(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sync failed: $error'),
        ),
      );
    } finally {
      final finalState = ref.read(syncStateProvider);

      if (finalState.status == SyncStateStatus.syncing) {
        ref.read(syncStateProvider.notifier).state = SyncState(
          status: SyncStateStatus.idle,
          lastSuccessfulSync: finalState.lastSuccessfulSync,
        );
      }
    }
  }

  String _formatSyncTime(DateTime? value) {
    if (value == null) {
      return 'Not available';
    }

    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '${value.day}/${value.month}/${value.year} $hour:$minute';
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    final locale = ref.read(localeProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇮🇩'),
                title: const Text('Bahasa Indonesia'),
                trailing: locale.languageCode == 'id'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () async {
                  await ref.read(localeProvider.notifier).changeLocale('id');

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              ListTile(
                leading: const Text('🇺🇸'),
                title: const Text('English'),
                trailing: locale.languageCode == 'en'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () async {
                  await ref.read(localeProvider.notifier).changeLocale('en');

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
