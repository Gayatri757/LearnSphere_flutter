import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class AddMcqScreen extends StatefulWidget {
  const AddMcqScreen({super.key});

  @override
  State<AddMcqScreen> createState() => _AddMcqScreenState();
}

class _AddMcqScreenState extends State<AddMcqScreen> {
  final questionController = TextEditingController();

  final option1Controller = TextEditingController();

  final option2Controller = TextEditingController();

  final option3Controller = TextEditingController();

  final option4Controller = TextEditingController();

  final explanationController = TextEditingController();

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

  String correctAnswer = "Option 1";

  bool isPremium = false;

  bool isLoading = false;

  Future<void> addMcq() async {
    if (questionController.text.isEmpty ||
        option1Controller.text.isEmpty ||
        option2Controller.text.isEmpty ||
        option3Controller.text.isEmpty ||
        option4Controller.text.isEmpty) {
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

      final response = await http.post(
        Uri.parse(
          "${ApiService.baseUrl}/add-mcq",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "subject": selectedSubject,
          "question": questionController.text,
          "option1": option1Controller.text,
          "option2": option2Controller.text,
          "option3": option3Controller.text,
          "option4": option4Controller.text,
          "correct_answer": correctAnswer,
          "explanation": explanationController.text,
          "is_premium": isPremium.toString(),
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"]),
        ),
      );

      questionController.clear();

      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();

      explanationController.clear();
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

  Widget buildField(
    String title,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
        ),
        maxLines: title == "Question" ? 4 : 1,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
          filled: true,
          fillColor: Colors.white.withValues(
            alpha: 0.05,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Add MCQ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildField(
              "Question",
              questionController,
            ),
            buildField(
              "Option 1",
              option1Controller,
            ),
            buildField(
              "Option 2",
              option2Controller,
            ),
            buildField(
              "Option 3",
              option3Controller,
            ),
            buildField(
              "Option 4",
              option4Controller,
            ),
            buildField(
              "Explanation",
              explanationController,
            ),
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
                items: subjects.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s),
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
                value: correctAnswer,
                dropdownColor: const Color(0xFF0B1622),
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(
                  color: Colors.white,
                ),
                items: [
                  "Option 1",
                  "Option 2",
                  "Option 3",
                  "Option 4",
                ].map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    correctAnswer = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: isPremium,
              onChanged: (value) {
                setState(() {
                  isPremium = value;
                });
              },
              title: const Text(
                "Premium MCQ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : addMcq,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Add MCQ",
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
