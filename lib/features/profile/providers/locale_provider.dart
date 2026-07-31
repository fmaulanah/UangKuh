import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends Notifier<Locale> {
  static const _key = 'app_locale';

  @override
  Locale build() {
    return const Locale('id');
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();

    final code = prefs.getString(_key);

    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> changeLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, code);

    state = Locale(code);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
