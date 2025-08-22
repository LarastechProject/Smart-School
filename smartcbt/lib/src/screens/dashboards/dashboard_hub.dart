import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/user_repository.dart';
import 'student_dashboard.dart';
import 'teacher_dashboard.dart';
import 'admin_dashboard.dart';
import 'super_admin_dashboard.dart';
import 'parent_dashboard.dart';

class DashboardHub extends ConsumerWidget {
  const DashboardHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentAppUserProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) return const Scaffold(body: Center(child: Text('No user profile.')));
        if (user.isSuperAdmin) return const SuperAdminDashboard();
        if (user.isAdmin) return const AdminDashboard();
        if (user.isTeacher) return const TeacherDashboard();
        if (user.isParent) return const ParentDashboard();
        return const StudentDashboard();
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}