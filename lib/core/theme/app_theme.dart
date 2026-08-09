import 'package:flutter/material.dart';

class AppTheme {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color accentBlue = Color(0xFF42A5F5);

  // DARK
  static const Color darkBackground = Color(0xFF020B16);
  static const Color darkSurface = Color(0xFF0B1727);
  static const Color darkCard = Color(0xFF0D1B2A);

  // LIGHT
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: lightBackground,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    ),

    cardColor: lightCard,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.black87,
      iconTheme: IconThemeData(
        color: Colors.black87,
      ),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        color: Colors.black54,
      ),
      bodySmall: TextStyle(
        color: Colors.black54,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,

      hintStyle: const TextStyle(
        color: Colors.black45,
      ),

      labelStyle: const TextStyle(
        color: Colors.black54,
      ),

      prefixIconColor: Colors.black54,
      suffixIconColor: Colors.black54,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: accentBlue,
          width: 1.5,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: lightCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Colors.black12,
    ),

    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.black45,
      type: BottomNavigationBarType.fixed,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return accentBlue;
          }
          return Colors.grey;
        },
      ),
    ),
  );

  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: darkBackground,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
    ),

    cardColor: darkCard,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
      ),
      bodySmall: TextStyle(
        color: Colors.white60,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(
        alpha: 0.05,
      ),

      hintStyle: const TextStyle(
        color: Colors.white54,
      ),

      labelStyle: const TextStyle(
        color: Colors.white70,
      ),

      prefixIconColor: Colors.white70,
      suffixIconColor: Colors.white70,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: accentBlue,
          width: 1.5,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Colors.white12,
    ),

    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: accentBlue,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return accentBlue;
          }
          return Colors.grey;
        },
      ),
    ),
  );
}