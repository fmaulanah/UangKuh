import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Me',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
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
      ],
    );
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
