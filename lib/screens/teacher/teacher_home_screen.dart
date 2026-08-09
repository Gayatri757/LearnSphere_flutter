import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/ui/login_screen.dart';

import '../../features/teacher/ui/upload_notes_screen.dart';
import '../../features/teacher/ui/upload_video_screen.dart';
import 'teacher_analytics_screen.dart';
import 'create_test_screen.dart';
import '../../features/teacher/ui/teacher_videos_screen.dart';
import '../../features/teacher/ui/teacher_notes_screen.dart';
import '../../features/teacher/ui/add_mcq_screen.dart';
import '../../features/teacher/ui/bulk_upload_mcq_screen.dart';
import '../../features/teacher/ui/create_plan_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final List<Map<String, dynamic>> teacherOptions = [
    {
      "title": "Upload Notes",
      "icon": Icons.note_add,
      "screen": const UploadNotesScreen(),
    },
    {
      "title": "Add Lectures",
      "icon": Icons.video_library,
      "screen": const UploadVideoScreen(),
    },
    {
      "title": "Create Tests",
      "icon": Icons.assignment,
      "screen": const CreateTestScreen(),
    },
    {
      "title": "Analytics",
      "icon": Icons.bar_chart,
      "screen": const TeacherAnalyticsScreen(),
    },
    {
      "title": "Manage Videos",
      "icon": Icons.video_library,
      "screen": const TeacherVideosScreen(),
    },
    {
      "title": "Manage Notes",
      "icon": Icons.note,
      "screen": const TeacherNotesScreen(),
    },
    {
      "title": "Add MCQ",
      "icon": Icons.add_circle,
      "screen": const AddMcqScreen(),
    },
    {
      "title": "Bulk Upload MCQs",
      "icon": Icons.upload_file,
      "screen": const BulkUploadMcqScreen(),
    },
    {
      "title": "Create Plan",
      "icon": Icons.calendar_month,
      "screen": const CreatePlanScreen(),
    },
  ];

  void navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive values
    final bool isSmallScreen = screenWidth < 400;

    final double titleFontSize = isSmallScreen ? 23 : 28;
    final double subtitleFontSize = isSmallScreen ? 13 : 15;
    final double actionTitleFontSize = isSmallScreen ? 19 : 22;
    final double iconSize = isSmallScreen ? 48 : 55;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            isSmallScreen ? 15 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ============================================================
              // TOP BAR
              // ============================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // LEFT SIDE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TEACHER PANEL",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Manage Your Content & Students",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // RIGHT SIDE BUTTONS
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // Notification
                      Container(
                        padding: EdgeInsets.all(
                          isSmallScreen ? 10 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF032B45),
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 14 : 16,
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: isSmallScreen ? 21 : 23,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Logout
                      GestureDetector(
                        onTap: logout,
                        child: Container(
                          padding: EdgeInsets.all(
                            isSmallScreen ? 10 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF032B45),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 14 : 16,
                            ),
                          ),
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: isSmallScreen ? 21 : 23,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ============================================================
              // HERO CARD
              // ============================================================

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  isSmallScreen ? 18 : 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),

                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0D5BD7),
                      Color(0xFF59B7FF),
                    ],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: Image.asset(
                        "assets/images/logo.png",

                        height: isSmallScreen ? 120 : 160,

                        width: double.infinity,

                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Empower Education Digitally",
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 23 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Upload content, create tests & guide students",
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ============================================================
              // SEARCH BAR
              // ============================================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFF031B2E),

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),

                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    icon: const Icon(
                      Icons.search,
                      color: Colors.white70,
                    ),

                    hintText: "Search students, lectures...",

                    hintStyle: const TextStyle(
                      color: Colors.white54,
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ============================================================
              // TEACHER ACTIONS TITLE
              // ============================================================

              Text(
                "Teacher Actions",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 27 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),

              // ============================================================
              // GRID
              // ============================================================

              GridView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: teacherOptions.length,

                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,

                  crossAxisSpacing: isSmallScreen ? 12 : 18,

                  mainAxisSpacing: isSmallScreen ? 12 : 18,

                  childAspectRatio: isSmallScreen ? 0.90 : 0.95,
                ),

                itemBuilder: (context, index) {
                  final item = teacherOptions[index];

                  return InkWell(
                    onTap: () => navigateTo(
                      item["screen"],
                    ),

                    borderRadius: BorderRadius.circular(28),

                    child: Container(
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(28),

                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF111C31),
                            Color(0xFF022135),
                          ],
                        ),

                        border: Border.all(
                          color: Colors.white10,
                        ),
                      ),

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Icon(
                            item["icon"],
                            size: iconSize,

                            color: const Color(
                              0xFF42B7FF,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),

                            child: Text(
                              item["title"],

                              textAlign: TextAlign.center,

                              maxLines: 2,

                              overflow:
                                  TextOverflow.ellipsis,

                              style: TextStyle(
                                color: Colors.white,

                                fontSize:
                                    actionTitleFontSize,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // ============================================================
              // STATS CARD
              // ============================================================

              Container(
                width: double.infinity,

                padding: EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: isSmallScreen ? 10 : 22,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFF111C31),

                  borderRadius: BorderRadius.circular(24),
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,

                  children: [

                    // STUDENTS
                    Column(
                      children: [
                        Text(
                          "1200+",

                          style: TextStyle(
                            color: const Color(0xFF42B7FF),
                            fontSize:
                                isSmallScreen ? 22 : 26,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Students",

                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    // LECTURES
                    Column(
                      children: [
                        Text(
                          "85",

                          style: TextStyle(
                            color: const Color(0xFF42B7FF),
                            fontSize:
                                isSmallScreen ? 22 : 26,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Lectures",

                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    // TESTS
                    Column(
                      children: [
                        Text(
                          "42",

                          style: TextStyle(
                            color: const Color(0xFF42B7FF),
                            fontSize:
                                isSmallScreen ? 22 : 26,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Tests",

                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}