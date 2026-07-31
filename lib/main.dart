import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/profile/providers/locale_provider.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  await container.read(localeProvider.notifier).loadLocale();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const UangKuhApp(),
    ),
  );
}
