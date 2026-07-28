import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }
}
