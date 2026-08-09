import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class OtpService {
  // ================= SEND OTP =================

  static Future<Map<String, dynamic>> sendOtp(
    String email,
  ) async {
    final response = await http.post(
      Uri.parse(
        "${ApiService.baseUrl}/send-otp",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
      }),
    );

    final data = jsonDecode(response.body);

    return data;
  }

  // ================= VERIFY OTP =================

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiService.baseUrl}/verify-otp",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    final data = jsonDecode(response.body);

    return data;
  }
}
