import 'package:flutter/material.dart';


class StudyGroupPage extends StatelessWidget {
  const StudyGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Groups')),
      body: const Center(child: Text('Study group details go here.')),
    );
  }
}