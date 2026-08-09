import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String baseUrl = "https://tac-the-apex-clinician.onrender.com";

  static Future<bool> sendOTP(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return response.statusCode == 200;
  }

  static Future<bool> verifyOTP(
    String email,
    String otp,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    return response.statusCode == 200;
  }

  static Future<bool> resetPassword(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reset-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return response.statusCode == 200;
  }
}
