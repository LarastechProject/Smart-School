import 'package:flutter/material.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Manage Exams')),
          ListTile(title: Text('Review Theory Answers')),
          ListTile(title: Text('Compute Academic Records')),
          ListTile(title: Text('Export Reports')),
          ListTile(title: Text('Notify Students & Parents')),
          ListTile(title: Text('Messages')),
        ],
      ),
    );
  }
}