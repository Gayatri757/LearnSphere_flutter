import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class TeacherAnalyticsScreen extends StatefulWidget {
  const TeacherAnalyticsScreen({
    super.key,
  });

  @override
  State<TeacherAnalyticsScreen> createState() => _TeacherAnalyticsScreenState();
}

class _TeacherAnalyticsScreenState extends State<TeacherAnalyticsScreen> {
  Map analytics = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiService.baseUrl}/teacher-analytics",
        ),
      );

      final data = jsonDecode(
        response.body,
      );

      setState(() {
        analytics = data;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Teacher Analytics",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                buildCard(
                  "Students",
                  analytics["total_students"].toString(),
                  Icons.people,
                ),
                buildCard(
                  "Premium",
                  analytics["premium_students"].toString(),
                  Icons.workspace_premium,
                ),
                buildCard(
                  "MCQs",
                  analytics["total_mcqs"].toString(),
                  Icons.quiz,
                ),
                buildCard(
                  "Notes",
                  analytics["total_notes"].toString(),
                  Icons.note,
                ),
                buildCard(
                  "Videos",
                  analytics["total_videos"].toString(),
                  Icons.video_library,
                ),
                buildCard(
                  "Active Users",
                  analytics["active_users"].toString(),
                  Icons.online_prediction,
                ),
              ],
            ),
    );
  }

  Widget buildCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.05,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 40,
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
