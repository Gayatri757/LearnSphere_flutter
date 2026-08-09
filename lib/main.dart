import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'services/theme_manager.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // PORTRAIT ONLY
  // ============================================================

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ============================================================
  // INITIALIZE THEME
  // ============================================================

  await ThemeManager.instance.initialize();

  // ============================================================
  // START APP
  // ============================================================

  runApp(const LearnSphereApp());
}

// ================================================================
// APP
// ================================================================

class LearnSphereApp extends StatelessWidget {
  const LearnSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable:
          ThemeManager.instance.themeNotifier,

      builder: (
        context,
        themeMode,
        child,
      ) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'LearnSphere',
          navigatorKey: ApiService.navigatorKey,

          // ======================================================
          // THEME
          // ======================================================

          theme: AppTheme.lightTheme,

          darkTheme: AppTheme.darkTheme,

          themeMode: themeMode,

          // ======================================================
          // START SCREEN
          // ======================================================

          home: const SplashScreen(),
        );
      },
    );
  }
}