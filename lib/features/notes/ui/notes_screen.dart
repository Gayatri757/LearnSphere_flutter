import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';
import 'pdf_viewer_screen.dart';

class NotesScreen extends StatefulWidget {
  final String subject;

  const NotesScreen({
    super.key,
    required this.subject,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List notes = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final token = await ApiService.getToken();

      final response = await http.get(
        Uri.parse(
          "${ApiService.baseUrl}/get-notes",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      final filteredNotes = data.where((note) {
        return note["subject"].toString().toLowerCase() ==
            widget.subject.toLowerCase();
      }).toList();

      setState(() {
        notes = filteredNotes;

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
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (notes.isEmpty) {
      return const Center(
        child: Text(
          "No Notes Available",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return Container(
          margin: const EdgeInsets.only(
            bottom: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withValues(
              alpha: 0.05,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () {
                // PREMIUM LOCK

                if (note["locked"] == true) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text(
                        "Premium Note",
                      ),
                      content: const Text(
                        "Upgrade to Premium to access this note.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );

                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfViewerScreen(
                      pdfUrl: note["file_url"],
                      title: note["title"],
                    ),
                  ),
                );
              },
              leading: const Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 40,
              ),
              title: Text(
                note["title"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                note["subject"],
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              trailing: note["locked"] == true
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: const Text(
                        "PREMIUM",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white54,
                    ),
            ),
          ),
        );
      },
    );
  }
}
