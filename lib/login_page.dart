import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'scan_document_page.dart';
import 'auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User? user = await AuthService().signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ScanDocumentPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to sign in with Google')),
              );
            }
          },
          child: const Text('Login with Google'),
        ),
      ),
    );
  }
}
