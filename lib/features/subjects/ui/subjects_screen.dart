import 'package:flutter/material.dart';

import '../../notes/ui/notes_screen.dart';

import '../../qbank/mcq_screen.dart';

import '../../videos/video_list_screen.dart';

class SubjectsScreen extends StatelessWidget {
  final String openType;

  const SubjectsScreen({
    super.key,
    this.openType = "video",
  });

  static const List<Map<String, dynamic>> subjects = [
    {
      "name": "Anatomy",
      "icon": Icons.accessibility_new,
    },
    {
      "name": "Physiology",
      "icon": Icons.favorite,
    },
    {
      "name": "Biochemistry",
      "icon": Icons.science,
    },
    {
      "name": "Pathology",
      "icon": Icons.biotech,
    },
    {
      "name": "Pharmacology",
      "icon": Icons.medication,
    },
    {
      "name": "Microbiology",
      "icon": Icons.coronavirus,
    },
    {
      "name": "ENT",
      "icon": Icons.hearing,
    },
    {
      "name": "Ophthalmology",
      "icon": Icons.remove_red_eye,
    },
    {
      "name": "Medicine",
      "icon": Icons.local_hospital,
    },
    {
      "name": "Surgery",
      "icon": Icons.medical_services,
    },
    {
      "name": "Pediatrics",
      "icon": Icons.child_care,
    },
    {
      "name": "Orthopedics",
      "icon": Icons.accessible_forward,
    },
    {
      "name": "Dermatology",
      "icon": Icons.spa,
    },
    {
      "name": "Radiology",
      "icon": Icons.monitor,
    },
    {
      "name": "Psychiatry",
      "icon": Icons.psychology,
    },
    {
      "name": "OBGY",
      "icon": Icons.pregnant_woman,
    },
    {
      "name": "Community Medicine",
      "icon": Icons.groups,
    },
    {
      "name": "Forensic Medicine",
      "icon": Icons.gavel,
    },
    {
      "name": "Anaesthesia",
      "icon": Icons.air,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Subjects",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: GridView.builder(
          itemCount: subjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final subject = subjects[index];

            return GestureDetector(
              onTap: () {
                Widget screen;

                // ================= NOTES =================

                if (openType == "notes") {
                  screen = NotesScreen(
                    subject: subject["name"],
                  );
                }

                // ================= MCQ =================

                else if (openType == "mcq") {
                  screen = McqScreen(
                    subject: subject["name"],
                  );
                }

                // ================= VIDEOS =================

                else {
                  screen = VideoListScreen(
                    subject: subject["name"],
                  );
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => screen,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      subject["icon"],
                      size: 50,
                      color: const Color(0xFF42A5F5),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        subject["name"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
