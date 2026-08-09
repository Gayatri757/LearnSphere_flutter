import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';
import 'verify_otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signup() async {
    // =========================================
    // VALIDATION
    // =========================================

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // =========================================
      // SEND OTP
      // =========================================

      final otpResponse = await http.post(
        Uri.parse(
          "${ApiService.baseUrl}/send-otp",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
        }),
      );

      debugPrint(
        "OTP STATUS: ${otpResponse.statusCode}",
      );

      debugPrint(
        "OTP BODY: ${otpResponse.body}",
      );

      // =========================================
      // SAFE JSON PARSE
      // =========================================

      Map<String, dynamic> otpData = {};

      try {
        otpData = jsonDecode(otpResponse.body);
      } catch (e) {
        throw Exception(
          "Server returned invalid response",
        );
      }

      if (!mounted) return;

      // =========================================
      // OTP SUCCESS
      // =========================================

      if (otpResponse.statusCode == 200 && otpData["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "OTP Sent Successfully",
            ),
          ),
        );

        // =========================================
        // NAVIGATE TO OTP SCREEN
        // =========================================

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOtpScreen(
              email: emailController.text.trim(),
              name: nameController.text.trim(),
              password: passwordController.text.trim(),
            ),
          ),
        );
      }

      // =========================================
      // OTP FAILED
      // =========================================

      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              otpData["message"] ?? "Failed to send OTP",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("SIGNUP ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // =========================================
            // NAME FIELD
            // =========================================

            TextField(
              controller: nameController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: const TextStyle(
                  color: Colors.white70,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================================
            // EMAIL FIELD
            // =========================================

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(
                  color: Colors.white70,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================================
            // PASSWORD FIELD
            // =========================================

            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(
                  color: Colors.white70,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // =========================================
            // SIGNUP BUTTON
            // =========================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================================
            // LOGIN NAVIGATION
            // =========================================

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Sign In",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
