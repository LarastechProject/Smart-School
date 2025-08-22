import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Exam Management')),
          ListTile(title: Text('Export Reports')),
          ListTile(title: Text('Notify')),
          ListTile(title: Text('Messages')),
        ],
      ),
    );
  }
}