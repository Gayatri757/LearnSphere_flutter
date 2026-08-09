import 'package:flutter/material.dart';

class CreateTestScreen extends StatelessWidget {
  const CreateTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Test"),
      ),
      body: const Center(
        child: Text("Create Test Screen"),
      ),
    );
  }
}
