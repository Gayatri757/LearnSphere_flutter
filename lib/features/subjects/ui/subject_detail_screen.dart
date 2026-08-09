import 'package:flutter/material.dart';

import '../../videos/video_list_screen.dart';
import '../../notes/ui/notes_screen.dart';
import '../../qbank/mcq_screen.dart';

class SubjectDetailScreen extends StatelessWidget {
  final String subject;

  const SubjectDetailScreen({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            subject,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF42A5F5),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(
                icon: Icon(Icons.play_circle_fill),
                text: "Lectures",
              ),
              Tab(
                icon: Icon(Icons.menu_book),
                text: "Notes",
              ),
              Tab(
                icon: Icon(Icons.quiz),
                text: "QBank",
              ),
              Tab(
                icon: Icon(Icons.analytics),
                text: "Tests",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// VIDEOS
            VideoListScreen(
              subject: subject,
            ),

            /// NOTES
            NotesScreen(
              subject: subject,
            ),

            /// QBANK
            McqScreen(
              subject: subject,
            ),

            /// TESTS
            _comingSoon(),
          ],
        ),
      ),
    );
  }

  Widget _comingSoon() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.08),
              Colors.white.withValues(alpha: 0.03),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.analytics,
              color: Color(0xFF42A5F5),
              size: 60,
            ),
            SizedBox(height: 20),
            Text(
              "Test Series Coming Soon",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Grand tests & analytics will appear here",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
