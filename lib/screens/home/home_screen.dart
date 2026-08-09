import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF020B16) : Colors.white;
    final cardColor = isDark ? const Color(0xFF0D1B2A) : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          "THE APEX CLINICIAN",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDark = !isDark;
              });
            },
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HERO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              child: Column(
                children: [
                  /// REMOVE IMAGE TEMPORARILY
                  const Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                    size: 90,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Learn Smarter. Heal Better.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "AI Powered Medical Learning Platform",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// SEARCH BAR
            TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: cardColor,
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Quick Access",
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                FeatureCard(
                  icon: Icons.play_circle_fill,
                  title: "Lectures",
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                FeatureCard(
                  icon: Icons.menu_book,
                  title: "Notes",
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                FeatureCard(
                  icon: Icons.quiz,
                  title: "QBank",
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                FeatureCard(
                  icon: Icons.analytics,
                  title: "Tests",
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                FeatureCard(
                  icon: Icons.psychology,
                  title: "AI Tools",
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                FeatureCard(
                  icon: Icons.local_hospital,
                  title: "Clinical Cases",
                  cardColor: cardColor,
                  textColor: textColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color cardColor;
  final Color textColor;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 42,
            color: Colors.blue,
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
