import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../features/subjects/ui/subjects_screen.dart';
import '../screens/ai/ai_screen.dart';
import '../screens/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  late final List<Widget> screens = [
    const HomeScreen(),
    const SubjectsScreen(),
    const AiScreen(),
    const ProfileScreen(),
  ];

  void onTap(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF08111F),
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 18,
        ),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: const Color(0xFF0B1320),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.15),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(
                icon: Icons.home_rounded,
                label: "Home",
                current: index == 0,
                onPressed: () => onTap(0),
              ),
              navItem(
                icon: Icons.menu_book_rounded,
                label: "Subjects",
                current: index == 1,
                onPressed: () => onTap(1),
              ),
              navItem(
                icon: Icons.auto_awesome,
                label: "AI",
                current: index == 2,
                onPressed: () => onTap(2),
              ),
              navItem(
                icon: Icons.person_rounded,
                label: "Profile",
                current: index == 3,
                onPressed: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required bool current,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: current
              ? const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: current ? Colors.white : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: current ? Colors.white : Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
