import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: navigationShell,
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
              ),
              selectedIcon: Icon(
                Icons.home_rounded,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.receipt_long_outlined,
              ),
              selectedIcon: Icon(
                Icons.receipt_long_rounded,
              ),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.event_repeat_outlined,
              ),
              selectedIcon: Icon(
                Icons.event_repeat_rounded,
              ),
              label: 'Plan',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline_rounded,
              ),
              selectedIcon: Icon(
                Icons.person_rounded,
              ),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
}
