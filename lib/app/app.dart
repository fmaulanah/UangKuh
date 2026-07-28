import 'package:flutter/material.dart';
import 'theme.dart';

class UangKuhApp extends StatelessWidget {
  const UangKuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UangKuh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('UangKuh'),
        ),
        body: const Center(
          child: Text('UangKuh is ready!'),
        ),
      ),
    );
  }
}
