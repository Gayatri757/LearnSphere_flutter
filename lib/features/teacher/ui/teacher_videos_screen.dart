import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class TeacherVideosScreen extends StatefulWidget {
  const TeacherVideosScreen({super.key});

  @override
  State<TeacherVideosScreen> createState() => _TeacherVideosScreenState();
}

class _TeacherVideosScreenState extends State<TeacherVideosScreen> {
  List videos = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchVideos();
  }

  Future<void> fetchVideos() async {
    final token = await ApiService.getToken();

    final response = await http.get(
      Uri.parse(
        "${ApiService.baseUrl}/get-videos",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        videos = jsonDecode(response.body);

        isLoading = false;
      });
    }
  }

  Future<void> deleteVideo(int id) async {
    final token = await ApiService.getToken();

    final response = await http.delete(
      Uri.parse(
        "${ApiService.baseUrl}/delete-video/$id",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data["message"]),
      ),
    );

    fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Manage Videos",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];

                return Card(
                  color: Colors.white.withValues(
                    alpha: 0.05,
                  ),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      video["title"],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      video["subject"],
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteVideo(video["id"]);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
