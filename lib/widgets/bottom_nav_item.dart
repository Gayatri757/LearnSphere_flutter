import 'package:flutter/material.dart';

class PremiumBottomNavBar extends StatelessWidget {
  final int currentIndex;

  final Function(int) onTap;

  const PremiumBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 18,
      ),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFF0B1320),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.12),
              blurRadius: 20,
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
              index: 0,
            ),
            navItem(
              icon: Icons.menu_book_rounded,
              label: "Subjects",
              index: 1,
            ),
            navItem(
              icon: Icons.quiz_rounded,
              label: "Tests",
              index: 2,
            ),
            navItem(
              icon: Icons.auto_awesome,
              label: "AI",
              index: 3,
            ),
            navItem(
              icon: Icons.person_rounded,
              label: "Profile",
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isSelected
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
              color: isSelected ? Colors.white : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
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
