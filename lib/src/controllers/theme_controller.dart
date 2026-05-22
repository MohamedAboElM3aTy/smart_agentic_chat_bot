import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_controller.g.dart';

const _kThemeKey = 'theme_mode';

@riverpod
class ThemeController extends _$ThemeController {
  static const _dark = 'dark';
  static const _light = 'light';

  @override
  ThemeMode build() {
    _loadSaved();
    return ThemeMode.light; // default until prefs load
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeKey);
    if (saved != null) {
      state = saved == _light ? ThemeMode.light : ThemeMode.dark;
    }
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, next == ThemeMode.light ? _light : _dark);
  }

  bool get isDark => state == ThemeMode.dark;
}
