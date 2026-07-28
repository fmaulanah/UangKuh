import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class UangKuhApp extends StatelessWidget {
  const UangKuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UangKuh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
