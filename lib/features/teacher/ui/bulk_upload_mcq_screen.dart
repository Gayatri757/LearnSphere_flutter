import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class BulkUploadMcqScreen extends StatefulWidget {
  const BulkUploadMcqScreen({
    super.key,
  });

  @override
  State<BulkUploadMcqScreen> createState() => _BulkUploadMcqScreenState();
}

class _BulkUploadMcqScreenState extends State<BulkUploadMcqScreen> {
  bool isLoading = false;

  bool isPremium = false;

  String selectedSubject = "Anatomy";

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

  Future<void> uploadCsv() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["csv"],
      );

      if (result == null) return;

      File file = File(
        result.files.single.path!,
      );

      setState(() {
        isLoading = true;
      });

      final token = await ApiService.getToken();

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "${ApiService.baseUrl}/bulk-upload-mcqs",
        ),
      );

      request.headers["Authorization"] = "Bearer $token";

      // CSV FILE
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          file.path,
        ),
      );

      // SUBJECT
      request.fields["subject"] = selectedSubject;

      // PREMIUM
      request.fields["is_premium"] = isPremium.toString();

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "MCQs Uploaded Successfully",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

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
          "Bulk Upload MCQs",
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
            // SUBJECT
            const Text(
              "Select Subject",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

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

            const SizedBox(height: 30),

            // PREMIUM SWITCH
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.05,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Premium MCQs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    value: isPremium,
                    onChanged: (value) {
                      setState(() {
                        isPremium = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // UPLOAD BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : uploadCsv,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Select CSV & Upload",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
