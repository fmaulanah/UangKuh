import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

import '../features/auth/presentation/session_gate.dart';

class UangKuhApp extends StatelessWidget {
  const UangKuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UangKuh',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return SessionGate(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
