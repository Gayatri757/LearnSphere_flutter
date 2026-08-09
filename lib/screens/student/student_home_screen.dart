import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/ui/login_screen.dart';
import '../../features/plans/ui/plans_screen.dart';
import '../../features/subjects/ui/subjects_screen.dart';
import '../profile/profile_screen.dart';
import '../tests/tests_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  final String userEmail;

  const StudentHomeScreen({
    super.key,
    required this.userEmail,
  });

  @override
  State<StudentHomeScreen> createState() =>
      _StudentHomeScreenState();
}

class _StudentHomeScreenState
    extends State<StudentHomeScreen> {

  // =========================================================
  // NAVIGATION
  // =========================================================

  void navigate(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    const storage = FlutterSecureStorage();

    await storage.deleteAll();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool isDark =
        theme.brightness == Brightness.dark;

    // =========================================================
    // THEME COLORS
    // =========================================================

    final Color backgroundColor =
        theme.scaffoldBackgroundColor;

    
    final Color primaryText =
        theme.textTheme.bodyLarge?.color ??
            colors.onSurface;

    final Color secondaryText =
        theme.textTheme.bodyMedium?.color ??
            colors.onSurfaceVariant;

    final Color borderColor =
        isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.08);

    final Color iconBackground =
        isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04);

    final Color searchBackground =
        isDark
            ? const Color(0xFF0B1727)
            : Colors.white;

    final Color quickCardEnd =
        isDark
            ? const Color(0xFF08111F)
            : Colors.white;

    // =========================================================
    // QUICK ACCESS
    // =========================================================

    final List<Map<String, dynamic>> quickAccess = [
      {
        "title": "Lectures",
        "subtitle": "Video Classes",
        "icon": Icons.play_circle_fill,
        "color": const Color(0xFF42A5F5),
        "screen": const SubjectsScreen(
          openType: "video",
        ),
      },
      {
        "title": "Notes",
        "subtitle": "Study Material",
        "icon": Icons.menu_book,
        "color": const Color(0xFF26C6DA),
        "screen": const SubjectsScreen(
          openType: "notes",
        ),
      },
      {
        "title": "QBank",
        "subtitle": "Practice MCQs",
        "icon": Icons.quiz,
        "color": const Color(0xFFFF7043),
        "screen": const SubjectsScreen(
          openType: "mcq",
        ),
      },
      {
        "title": "Tests",
        "subtitle": "Mock Exams",
        "icon": Icons.bar_chart,
        "color": const Color(0xFF66BB6A),
        "screen": const TestsScreen(),
      },
      {
        "title": "Premium",
        "subtitle": "Subscription Plans",
        "icon": Icons.workspace_premium,
        "color": const Color(0xFFFFC107),
        "screen": PlansScreen(
          userEmail: widget.userEmail,
        ),
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {

            final double screenWidth =
                constraints.maxWidth;

            final double horizontalPadding =
                screenWidth < 360 ? 14 : 20;

            final double titleFontSize =
                screenWidth < 360 ? 20 : 24;

            final double heroFontSize =
                screenWidth < 360 ? 24 : 28;

            return SingleChildScrollView(
              padding:
                  EdgeInsets.all(horizontalPadding),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // =========================================================
                  // TOP BAR
                  // =========================================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,

                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment:
                                  Alignment.centerLeft,

                              child: Text(
                                "THE LEARNSPHERE",

                                style: TextStyle(
                                  color: primaryText,
                                  fontSize:
                                      titleFontSize,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "Welcome Back 👋",

                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,

                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // =====================================================
                      // NOTIFICATION
                      // =====================================================

                      Container(
                        padding:
                            const EdgeInsets.all(10),

                        decoration:
                            BoxDecoration(
                          color: iconBackground,

                          borderRadius:
                              BorderRadius.circular(14),

                          border: Border.all(
                            color: borderColor,
                          ),
                        ),

                        child: Icon(
                          Icons.notifications_none,

                          color: primaryText,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // =====================================================
                      // PROFILE
                      // =====================================================

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ProfileScreen(),
                            ),
                          );
                        },

                        child: Container(
                          padding:
                              const EdgeInsets.all(10),

                          decoration:
                              BoxDecoration(
                            color: iconBackground,

                            borderRadius:
                                BorderRadius.circular(14),

                            border: Border.all(
                              color: borderColor,
                            ),
                          ),

                          child: Icon(
                            Icons.person,

                            color: primaryText,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // =========================================================
                  // HERO CARD
                  // =========================================================

                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(
                      screenWidth < 360
                          ? 18
                          : 24,
                    ),

                    decoration:
                        BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(30),

                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xFF1565C0),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),

                    child: Column(
                      children: [

                        Container(
                          height:
                              screenWidth < 360
                                  ? 75
                                  : 95,

                          width:
                              screenWidth < 360
                                  ? 75
                                  : 95,

                          decoration:
                              BoxDecoration(
                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(24),
                          ),

                          child: Icon(
                            Icons.school,

                            size:
                                screenWidth < 360
                                    ? 42
                                    : 52,

                            color:
                                const Color(
                              0xFF1565C0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Learn Smarter.\nGrow Better.",

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                heroFontSize,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================================================
                  // SEARCH
                  // =========================================================

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    decoration:
                        BoxDecoration(
                      color: searchBackground,

                      borderRadius:
                          BorderRadius.circular(22),

                      border: Border.all(
                        color: borderColor,
                      ),
                    ),

                    child: TextField(
                      style: TextStyle(
                        color: primaryText,
                      ),

                      decoration:
                          InputDecoration(
                        border:
                            InputBorder.none,

                        icon: Icon(
                          Icons.search,
                          color: secondaryText,
                        ),

                        hintText:
                            "Search lectures, notes, MCQs...",

                        hintStyle: TextStyle(
                          color: secondaryText
                              .withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // =========================================================
                  // QUICK ACCESS TITLE
                  // =========================================================

                  Text(
                    "Quick Access",

                    style: TextStyle(
                      color: primaryText,

                      fontSize:
                          screenWidth < 360
                              ? 24
                              : 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================================================
                  // GRID
                  // =========================================================

                  GridView.builder(
                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount:
                        quickAccess.length,

                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          screenWidth >= 700
                              ? 3
                              : 2,

                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,

                      childAspectRatio:
                          screenWidth < 360
                              ? 0.78
                              : screenWidth < 420
                                  ? 0.82
                                  : screenWidth < 700
                                      ? 0.88
                                      : 1.0,
                    ),

                    itemBuilder:
                        (context, index) {

                      final item =
                          quickAccess[index];

                      final Color itemColor =
                          item["color"]
                              as Color;

                      return InkWell(
                        onTap: () {
                          navigate(
                            item["screen"],
                          );
                        },

                        borderRadius:
                            BorderRadius.circular(24),

                        child: Container(
                          decoration:
                              BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(24),

                            gradient:
                                LinearGradient(
                              colors: [
                                itemColor
                                    .withValues(
                                  alpha: isDark
                                      ? 0.22
                                      : 0.12,
                                ),

                                quickCardEnd,
                              ],

                              begin:
                                  Alignment.topLeft,

                              end:
                                  Alignment.bottomRight,
                            ),

                            border: Border.all(
                              color: borderColor,
                            ),
                          ),

                          child: Padding(
                            padding:
                                EdgeInsets.all(
                              screenWidth < 360
                                  ? 11
                                  : 14,
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [

                                // =================================================
                                // ICON
                                // =================================================

                                Container(
                                  padding:
                                      EdgeInsets.all(
                                    screenWidth < 360
                                        ? 9
                                        : 11,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        itemColor
                                            .withValues(
                                      alpha:
                                          isDark
                                              ? 0.18
                                              : 0.10,
                                    ),

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      16,
                                    ),
                                  ),

                                  child: Icon(
                                    item["icon"],

                                    color:
                                        itemColor,

                                    size:
                                        screenWidth <
                                                360
                                            ? 28
                                            : 32,
                                  ),
                                ),

                                // =================================================
                                // TEXT
                                // =================================================

                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      item["title"],

                                      maxLines: 1,

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style:
                                          TextStyle(
                                        color:
                                            primaryText,

                                        fontSize:
                                            screenWidth <
                                                    360
                                                ? 17
                                                : 19,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      item["subtitle"],

                                      maxLines: 1,

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style:
                                          TextStyle(
                                        color:
                                            secondaryText,

                                        fontSize:
                                            screenWidth <
                                                    360
                                                ? 11
                                                : 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}