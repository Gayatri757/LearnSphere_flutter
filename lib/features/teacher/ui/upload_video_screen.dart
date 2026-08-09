import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final titleController = TextEditingController();

  final youtubeController = TextEditingController();

  bool isLoading = false;

  bool isPremium = false;

  final List<String> subjects = [
    "Anatomy",
    "Physiology",
    "Biochemistry",
    "Pathology",
    "Pharmacology",
    "Microbiology",
    "Forensic Medicine",
    "Community Medicine (PSM)",
    "ENT",
    "Ophthalmology",
    "Medicine",
    "Surgery",
    "Pediatrics",
    "Orthopedics",
    "Dermatology",
    "Psychiatry",
    "Obstetrics & Gynecology",
    "Radiology",
    "Anesthesia",
  ];

  String selectedSubject = "Anatomy";

  Future<void> uploadVideo() async {
    if (titleController.text.isEmpty || youtubeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill all fields"),
        ),
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final token = await ApiService.getToken();

      final response = await http.post(
        Uri.parse(
          "${ApiService.baseUrl}/upload-video",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": titleController.text,
          "youtube_url": youtubeController.text,
          "subject": selectedSubject,
          "is_premium": isPremium,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"],
            ),
          ),
        );

        titleController.clear();

        youtubeController.clear();

        setState(() {
          isPremium = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ?? "Upload failed",
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Upload Video",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Video Title",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
                hintText: "Enter title",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "YouTube URL",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: youtubeController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
                hintText: "Paste YouTube URL",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Select Subject",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.05,
                ),
                borderRadius: BorderRadius.circular(
                  16,
                ),
              ),
              child: DropdownButton<String>(
                dropdownColor: const Color(0xFF0B1622),
                value: selectedSubject,
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(
                  color: Colors.white,
                ),
                items: subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: isPremium,
              activeThumbColor: Colors.blue,
              title: const Text(
                "Premium Video",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: const Text(
                "Only premium users can access",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  isPremium = value;
                });
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : uploadVideo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF42A5F5,
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Upload Video",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
