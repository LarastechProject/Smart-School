import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/landing_page.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboards/dashboard_hub.dart';
import '../screens/exams/token_verify_screen.dart';
import '../core/services.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(auth.asData?.valueChanges() ?? const Stream.empty()),
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const LandingPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/dashboard', builder: (context, state) => const DashboardHub()),
      GoRoute(path: '/exam/token', builder: (context, state) => const TokenVerifyScreen()),
    ],
    redirect: (context, state) {
      final loggedIn = auth.valueOrNull != null;
      final isLogging = state.matchedLocation == '/login';
      if (!loggedIn && !isLogging) return '/login';
      if (loggedIn && (isLogging || state.matchedLocation == '/')) return '/dashboard';
      return null;
    },
  );
});