import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Take Exam (Enter Token)'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.of(context).pushNamed('/exam/token'),
          ),
          const Divider(),
          const ListTile(title: Text('Messages'), subtitle: Text('Open messaging')),        
        ],
      ),
    );
  }
}