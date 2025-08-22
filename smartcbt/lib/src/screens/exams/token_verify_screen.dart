import 'package:flutter/material.dart';

class TokenVerifyScreen extends StatefulWidget {
  const TokenVerifyScreen({super.key});
  @override
  State<TokenVerifyScreen> createState() => _TokenVerifyScreenState();
}

class _TokenVerifyScreenState extends State<TokenVerifyScreen> {
  final TextEditingController _token = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Exam Token')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _token, decoration: const InputDecoration(labelText: 'Token')),            
            const SizedBox(height: 16),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _loading ? null : () async {
                setState(() { _loading = true; _error = null; });
                try {
                  // TODO: call token verification function and cache exam offline
                } catch (e) {
                  setState(() { _error = e.toString(); });
                } finally {
                  setState(() { _loading = false; });
                }
              },
              child: const Text('Verify & Start'),
            )
          ],
        ),
      ),
    );
  }
}