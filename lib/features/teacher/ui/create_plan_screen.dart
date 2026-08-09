import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  // =========================================
  // CONTROLLERS
  // =========================================

  final TextEditingController planNameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController durationController = TextEditingController();

  // =========================================
  // STATES
  // =========================================

  bool isLoading = false;

  bool loadingPlans = false;

  List plans = [];

  // =========================================
  // SUBJECT LIST
  // =========================================

  final List<String> subjects = [
    "Anatomy",
    "Physiology",
    "Biochemistry",
    "Pathology",
    "Pharmacology",
    "Microbiology",
    "ENT",
    "Ophthalmology",
    "Medicine",
    "Surgery",
    "Pediatrics",
    "Orthopedics",
    "Dermatology",
    "Radiology",
    "Psychiatry",
    "OBGY",
    "Community Medicine",
    "Forensic Medicine",
    "Anaesthesia"
  ];

  // =========================================
  // SELECTED SUBJECTS
  // =========================================

  List<String> selectedSubjects = [];

  // =========================================
  // INIT STATE
  // =========================================

  @override
  void initState() {
    super.initState();

    fetchPlans();
  }

  // =========================================
  // FETCH PLANS
  // =========================================

  Future<void> fetchPlans() async {
    setState(() {
      loadingPlans = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "${ApiService.baseUrl}/get-plans",
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          plans = jsonDecode(
            response.body,
          );
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loadingPlans = false;
      });
    }
  }

  // =========================================
  // DELETE PLAN
  // =========================================

  Future<void> deletePlan(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "${ApiService.baseUrl}/delete-plan/$id",
        ),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Plan Deleted",
            ),
          ),
        );

        fetchPlans();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // =========================================
  // CREATE PLAN
  // =========================================

  Future<void> createPlan() async {
    if (planNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        durationController.text.isEmpty ||
        selectedSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill all fields"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/create-plan"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "plan_name": planNameController.text,
          "subjects": selectedSubjects.join(","),
          "price": int.parse(priceController.text),
          "description": descriptionController.text,
          "duration_days": int.parse(durationController.text)
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Plan Created Successfully"),
          ),
        );

        // CLEAR FIELDS

        planNameController.clear();

        priceController.clear();

        descriptionController.clear();

        durationController.clear();

        setState(() {
          selectedSubjects.clear();
        });

        fetchPlans();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"]),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================================
  // UI
  // =========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Create Plan",
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
            // =====================================
            // PLAN NAME
            // =====================================

            TextField(
              controller: planNameController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Plan Name",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =====================================
            // PRICE
            // =====================================

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Price",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =====================================
            // DESCRIPTION
            // =====================================

            TextField(
              controller: descriptionController,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Plan Description",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =====================================
            // DURATION
            // =====================================

            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Duration (Days)",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =====================================
            // SUBJECT TITLE
            // =====================================

            const Text(
              "Select Subjects",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // =====================================
            // SUBJECT CHIPS
            // =====================================

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: subjects.map((subject) {
                final isSelected = selectedSubjects.contains(
                  subject,
                );

                return FilterChip(
                  label: Text(subject),
                  selected: isSelected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        selectedSubjects.add(
                          subject,
                        );
                      } else {
                        selectedSubjects.remove(
                          subject,
                        );
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // =====================================
            // CREATE BUTTON
            // =====================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : createPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Create Plan",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 40),

            // =====================================
            // CREATED PLANS
            // =====================================

            const Text(
              "Created Plans",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            loadingPlans
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 18,
                        ),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                          color: Colors.white.withValues(
                            alpha: 0.05,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    plan["plan_name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deletePlan(
                                      plan["id"],
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "₹${plan["price"]}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              plan["description"],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Duration: ${plan["duration_days"]} Days",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Subjects: ${plan["subjects"]}",
                              style: const TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
