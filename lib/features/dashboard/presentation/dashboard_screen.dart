import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton.icon(
            onPressed: () {
              context.push('/expense/new');
            },
            icon: const Icon(Icons.remove),
            label: const Text('Add Expense'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              context.push('/income/new');
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Income'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              context.push('/transfer/new');
            },
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Transfer'),
          ),
        ],
      ),
    );
  }
}
