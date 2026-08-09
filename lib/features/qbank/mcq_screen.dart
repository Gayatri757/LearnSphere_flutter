import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class McqScreen extends StatefulWidget {
  final String subject;

  const McqScreen({
    super.key,
    required this.subject,
  });

  @override
  State<McqScreen> createState() => _McqScreenState();
}

class _McqScreenState extends State<McqScreen> {
  List mcqs = [];

  bool isLoading = true;

  int currentIndex = 0;

  String? selectedAnswer;

  @override
  void initState() {
    super.initState();

    fetchMcqs();
  }

  Future<void> fetchMcqs() async {
    try {
      final token = await ApiService.getToken();

      final response = await http.get(
        Uri.parse(
          "${ApiService.baseUrl}/mcqs/${widget.subject}",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      setState(() {
        mcqs = data;

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
        elevation: 0,
        title: Text(
          widget.subject,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : mcqs.isEmpty
              ? const Center(
                  child: Text(
                    "No MCQs Available",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : buildMcq(),
    );
  }

  Widget buildMcq() {
    final mcq = mcqs[currentIndex];

    // PREMIUM LOCK
    if (mcq["locked"] == true) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.05,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                color: Colors.amber,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                "Premium MCQ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Upgrade to access all MCQs",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentIndex + 1}",
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              mcq["question"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            buildOption(
              mcq["option1"],
            ),

            buildOption(
              mcq["option2"],
            ),

            buildOption(
              mcq["option3"],
            ),

            buildOption(
              mcq["option4"],
            ),

            const SizedBox(height: 20),

            // RESULT + EXPLANATION
            if (selectedAnswer != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(
                  18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.06,
                  ),
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedAnswer == mcq["correct_answer"]
                          ? "✅ Correct Answer"
                          : "❌ Wrong Answer",
                      style: TextStyle(
                        color: selectedAnswer == mcq["correct_answer"]
                            ? Colors.green
                            : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Correct Answer: ${mcq["correct_answer"]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Explanation:\n${mcq["explanation"]}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (currentIndex < mcqs.length - 1) {
                    setState(() {
                      currentIndex++;

                      selectedAnswer = null;
                    });
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "MCQs Finished",
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                child: Text(
                  currentIndex == mcqs.length - 1 ? "Finish" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildOption(String option) {
    final mcq = mcqs[currentIndex];

    final correctAnswer = mcq["correct_answer"];

    bool isSelected = selectedAnswer == option;

    bool isCorrect = option == correctAnswer;

    Color bgColor = Colors.white.withValues(
      alpha: 0.08,
    );

    // WRONG SELECTED
    if (selectedAnswer != null && isSelected && !isCorrect) {
      bgColor = Colors.red;
    }

    // CORRECT ANSWER
    if (selectedAnswer != null && isCorrect) {
      bgColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          minimumSize: const Size(
            double.infinity,
            60,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
        ),

        // DISABLE AFTER SELECTING
        onPressed: selectedAnswer != null
            ? null
            : () {
                setState(() {
                  selectedAnswer = option;
                });
              },

        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            option,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
