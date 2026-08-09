import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class UploadNotesScreen extends StatefulWidget {
  const UploadNotesScreen({super.key});

  @override
  State<UploadNotesScreen> createState() => _UploadNotesScreenState();
}

class _UploadNotesScreenState extends State<UploadNotesScreen> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  File? selectedFile;

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

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = File(
          result.files.single.path!,
        );
      });
    }
  }

  Future<void> uploadNote() async {
    if (titleController.text.isEmpty || selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Title and file required",
          ),
        ),
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final token = await ApiService.getToken();

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "${ApiService.baseUrl}/upload-note",
        ),
      );

      request.headers["Authorization"] = "Bearer $token";

      request.fields["title"] = titleController.text;

      request.fields["description"] = descriptionController.text;

      request.fields["subject"] = selectedSubject;

      request.fields["is_premium"] = isPremium.toString();

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          selectedFile!.path,
        ),
      );

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      final data = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"]),
          ),
        );

        titleController.clear();

        descriptionController.clear();

        setState(() {
          selectedFile = null;

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
          content: Text(e.toString()),
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
          "Upload Notes",
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
              "Title",
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
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: "Enter title",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Description",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: "Enter description",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Subject",
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
                borderRadius: BorderRadius.circular(16),
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
                "Premium Note",
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
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pickFile,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  selectedFile == null ? "Pick PDF/File" : "File Selected",
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : uploadNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Upload Note",
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
