import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class TeacherNotesScreen extends StatefulWidget {
  const TeacherNotesScreen({super.key});

  @override
  State<TeacherNotesScreen> createState() => _TeacherNotesScreenState();
}

class _TeacherNotesScreenState extends State<TeacherNotesScreen> {
  List notes = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final token = await ApiService.getToken();

    final response = await http.get(
      Uri.parse(
        "${ApiService.baseUrl}/get-notes",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        notes = jsonDecode(response.body);

        isLoading = false;
      });
    }
  }

  Future<void> deleteNote(int id) async {
    final token = await ApiService.getToken();

    final response = await http.delete(
      Uri.parse(
        "${ApiService.baseUrl}/delete-note/$id",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      fetchNotes();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note deleted"),
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
          "Manage Notes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  color: Colors.white10,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      note["title"],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      note["subject"],
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteNote(note["id"]);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
