import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/firebase/firebase_options.dart';

import 'features/profile/providers/locale_provider.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final container = ProviderContainer();

  await container.read(localeProvider.notifier).loadLocale();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const UangKuhApp(),
    ),
  );
}
