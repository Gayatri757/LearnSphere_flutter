import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  // ============================================================
  // SINGLETON
  // ============================================================

  ThemeManager._privateConstructor();

  static final ThemeManager instance =
      ThemeManager._privateConstructor();

  // ============================================================
  // THEME STATE
  // ============================================================

  final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  // ============================================================
  // GETTERS
  // ============================================================

  bool get isDark =>
      themeNotifier.value == ThemeMode.dark;

  ThemeMode get themeMode =>
      themeNotifier.value;

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> initialize() async {
    final prefs =
        await SharedPreferences.getInstance();

    final isDarkMode =
        prefs.getBool("dark_mode") ?? true;

    themeNotifier.value = isDarkMode
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  // ============================================================
  // TOGGLE THEME
  // ============================================================

  Future<void> toggleTheme() async {
    final newMode = isDark
        ? ThemeMode.light
        : ThemeMode.dark;

    themeNotifier.value = newMode;

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      "dark_mode",
      newMode == ThemeMode.dark,
    );
  }

  // ============================================================
  // SET DARK MODE
  // ============================================================

  Future<void> setDarkMode(bool value) async {
    themeNotifier.value =
        value ? ThemeMode.dark : ThemeMode.light;

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      "dark_mode",
      value,
    );
  }
}