import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';
import 'login_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;

  const VerifyOtpScreen({
    super.key,
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();

  bool isLoading = false;

  Future<void> verifyOtp() async {
    // =========================================
    // VALIDATION
    // =========================================

    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter OTP"),
        ),
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // =========================================
      // VERIFY OTP API
      // =========================================

      final response = await http.post(
        Uri.parse(
          "${ApiService.baseUrl}/verify-otp",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": widget.email,
          "otp": otpController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      // =========================================
      // OTP VERIFIED
      // =========================================

      if (response.statusCode == 200 && data["success"] == true) {
        // =========================================
        // REGISTER USER
        // =========================================

        await ApiService.register(
          name: widget.name,
          email: widget.email,
          password: widget.password,
          role: "student",
        );

        if (!mounted) return;

        // =========================================
        // SUCCESS MESSAGE
        // =========================================

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Registration Successful",
            ),
          ),
        );

        // =========================================
        // MOVE TO LOGIN SCREEN
        // =========================================

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      }

      // =========================================
      // OTP FAILED
      // =========================================

      else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"]),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
        title: const Text(
          "Verify OTP",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Text(
              "Enter OTP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "OTP sent to ${widget.email}",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 40),

            // =========================================
            // OTP FIELD
            // =========================================

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Enter 6 digit OTP",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // =========================================
            // VERIFY BUTTON
            // =========================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : verifyOtp,
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
                        "Verify OTP",
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
