import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _schoolId = TextEditingController(text: 'default');
  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartCBT Auth')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 12),
                TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                if (!_isLogin) ...[
                  const SizedBox(height: 12),
                  TextField(controller: _schoolId, decoration: const InputDecoration(labelText: 'School ID')),
                ],
                const SizedBox(height: 16),
                if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _loading ? null : () async {
                    setState(() { _loading = true; _error = null; });
                    try {
                      final auth = ref.read(authControllerProvider);
                      if (_isLogin) {
                        await auth.signIn(_email.text.trim(), _password.text.trim());
                      } else {
                        await auth.signUp(_email.text.trim(), _password.text.trim(), schoolId: _schoolId.text.trim());
                      }
                      if (context.mounted) Navigator.of(context).pushReplacementNamed('/dashboard');
                    } catch (e) {
                      setState(() { _error = e.toString(); });
                    } finally {
                      if (mounted) setState(() { _loading = false; });
                    }
                  },
                  child: Text(_isLogin ? 'Login' : 'Create account'),
                ),
                TextButton(
                  onPressed: _loading ? null : () => setState(() { _isLogin = !_isLogin; }),
                  child: Text(_isLogin ? "Don't have an account? Sign up" : 'Have an account? Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}