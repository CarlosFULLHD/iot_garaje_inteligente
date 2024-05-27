// lib/views/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            authProvider.isLoading
                ? LoadingIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await authProvider.login(
                        _emailController.text,
                        _passwordController.text,
                      );

                      if (authProvider.isAuthenticated) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login failed')),
                        );
                      }
                    },
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
