import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/ui/login_screen.dart';
import '../student/student_home_screen.dart';
import '../teacher/teacher_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _glowAnimation = Tween<double>(
      begin: 0.35,
      end: 0.75,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    navigateUser();
  }

  Future<void> navigateUser() async {
    await Future.delayed(
      const Duration(milliseconds: 2800),
    );

    if (!mounted) return;

    const storage = FlutterSecureStorage();

    final token = await storage.read(key: "token");
    final role = await storage.read(key: "role");
    final email = await storage.read(key: "email") ?? "";

    debugPrint("========== SPLASH ==========");
    debugPrint("TOKEN = $token");
    debugPrint("ROLE  = $role");
    debugPrint("EMAIL = $email");
    debugPrint("============================");

    Widget nextScreen;

    if (token == null || token.isEmpty) {
      nextScreen = const LoginScreen();
    } else if (role == "student") {
      nextScreen = StudentHomeScreen(
        userEmail: email,
      );
    } else if (role == "teacher") {
      nextScreen = const TeacherHomeScreen();
    } else {
      nextScreen = const LoginScreen();
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => nextScreen,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final logoSize = size.width < 360
        ? 110.0
        : size.width < 600
            ? 135.0
            : 155.0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF020B16),
              Color(0xFF07182B),
              Color(0xFF0B2A4A),
              Color(0xFF0D4D83),
            ],
          ),
        ),
        child: Stack(
          children: [
            // TOP GLOW
            Positioned(
              top: -120,
              right: -90,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF42A5F5).withValues(
                    alpha: 0.10,
                  ),
                ),
              ),
            ),

            // BOTTOM GLOW
            Positioned(
              bottom: -130,
              left: -100,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1565C0).withValues(
                    alpha: 0.14,
                  ),
                ),
              ),
            ),

            // SMALL DECORATIVE CIRCLE
            Positioned(
              top: size.height * 0.20,
              left: size.width * 0.08,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF64B5F6).withValues(
                    alpha: 0.45,
                  ),
                ),
              ),
            ),

            // MAIN CONTENT
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LOGO
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF42A5F5)
                                      .withValues(
                                    alpha: _glowAnimation.value,
                                  ),
                                  blurRadius: 45,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: logoSize,
                                height: logoSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // BRAND NAME
                    const Text(
                      "THE LEARNSPHERE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // TAGLINE
                    Text(
                      "Learn Smarter. Grow Better.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: 0.72,
                        ),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.8,
                      ),
                    ),

                    const SizedBox(height: 42),

                    // LOADING INDICATOR
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF64B5F6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // VERSION / BRAND FOOTER
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Text(
                "YOUR LEARNING PLATFORM",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(
                    alpha: 0.35,
                  ),
                  fontSize: 10,
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}