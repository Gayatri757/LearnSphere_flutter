import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/ui/login_screen.dart';

class ApiService {
  // ============================================================
  // BASE URL
  // ============================================================

  static const String baseUrl =
      "https://tac-the-apex-clinician.onrender.com";

  // ============================================================
  // SECURE STORAGE
  // ============================================================

  static const FlutterSecureStorage storage =
      FlutterSecureStorage();

  // ============================================================
  // GLOBAL NAVIGATOR
  // ============================================================

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // ============================================================
  // SAVE LOGIN
  // ============================================================

  static Future<void> saveLoginData({
    required String token,
    required String role,
    required String email,
  }) async {
    await storage.write(
      key: "token",
      value: token,
    );

    await storage.write(
      key: "role",
      value: role,
    );

    await storage.write(
      key: "email",
      value: email,
    );
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  static Future<String?> getToken() async {
    return storage.read(key: "token");
  }

  // ============================================================
  // GET ROLE
  // ============================================================

  static Future<String?> getRole() async {
    return storage.read(key: "role");
  }

  // ============================================================
  // GET EMAIL
  // ============================================================

  static Future<String?> getEmail() async {
    return storage.read(key: "email");
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  static Future<void> logout() async {
    await storage.deleteAll();
  }

  // ============================================================
  // HANDLE EXPIRED TOKEN
  // ============================================================

  static Future<void> handleUnauthorized() async {
    debugPrint("=================================");
    debugPrint("AUTHENTICATION EXPIRED");
    debugPrint("Clearing stored login data...");
    debugPrint("=================================");

    await storage.deleteAll();

    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      return;
    }

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // ============================================================
  // AUTHENTICATED GET REQUEST
  // ============================================================

  static Future<http.Response> authenticatedGet(
    String endpoint,
  ) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      await handleUnauthorized();

      throw Exception("User not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    debugPrint(
      "GET $endpoint -> ${response.statusCode}",
    );

    // TOKEN EXPIRED
    if (response.statusCode == 401) {
      await handleUnauthorized();

      throw Exception("Session expired. Please login again.");
    }

    return response;
  }

  // ============================================================
  // LOGIN
  // ============================================================

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    Map<String, dynamic> data;

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      throw Exception("Invalid server response");
    }

    if (response.statusCode != 200) {
      throw Exception(
        data["message"] ??
            data["msg"] ??
            "Login failed",
      );
    }

    final token = data["token"];
    final role = data["role"];

    if (token == null) {
      throw Exception("Token missing");
    }

    if (role == null) {
      throw Exception("Role missing");
    }

    await saveLoginData(
      token: token.toString(),
      role: role.toString(),
      email: email,
    );

    return {
      "token": token,
      "role": role,
    };
  }

  // ============================================================
  // REGISTER
  // ============================================================

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      }),
    );

    Map<String, dynamic> data;

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      throw Exception("Invalid server response");
    }

    if (response.statusCode != 200) {
      throw Exception(
        data["message"] ?? "Registration failed",
      );
    }

    return data;
  }

  // ============================================================
  // SUBJECTS
  // ============================================================

  static Future<List<dynamic>> getSubjects() async {
    final response = await http.get(
      Uri.parse("$baseUrl/subjects"),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception("Failed to load subjects");
    }

    return data["subjects"];
  }

  // ============================================================
  // NOTES
  // ============================================================

  static Future<List<dynamic>> getNotes() async {
    final response = await authenticatedGet(
      "/get-notes",
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data["message"] ??
            data["msg"] ??
            "Failed to load notes",
      );
    }

    return data;
  }

  // ============================================================
  // NOTES BY SUBJECT
  // ============================================================

  static Future<List<dynamic>> getNotesBySubject(
    String subject,
  ) async {
    final response = await authenticatedGet(
      "/notes/$subject",
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data["message"] ??
            data["msg"] ??
            "Failed to load notes",
      );
    }

    return data;
  }

  // ============================================================
  // VIDEOS
  // ============================================================

  static Future<List<dynamic>> getVideos() async {
    final response = await authenticatedGet(
      "/get-videos",
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data["message"] ??
            data["msg"] ??
            "Failed to load videos",
      );
    }

    return data;
  }

  // ============================================================
  // VIDEOS BY SUBJECT
  // ============================================================

  static Future<List<dynamic>> getVideosBySubject(
    String subject,
  ) async {
    final response = await authenticatedGet(
      "/videos/$subject",
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data["message"] ??
            data["msg"] ??
            "Failed to load videos",
      );
    }

    return data;
  }

  // ============================================================
  // MCQs
  // ============================================================

  static Future<List<dynamic>> getMcqsBySubject(
    String subject,
  ) async {
    final response = await authenticatedGet(
      "/mcqs/$subject",
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data["message"] ??
            data["msg"] ??
            "Failed to load MCQs",
      );
    }

    return data;
  }
}