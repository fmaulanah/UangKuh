import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

import '../features/profile/providers/locale_provider.dart';
import '../features/auth/presentation/session_gate.dart';

class UangKuhApp extends ConsumerWidget {
  const UangKuhApp({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'UangKuh',
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return SessionGate(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
