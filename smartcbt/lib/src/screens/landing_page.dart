import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('SmartCBT', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('Multi-school CBT with offline exams, AI questions and more.'),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed('/login'),
                      child: const Text('Login / Signup'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Learn More'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}