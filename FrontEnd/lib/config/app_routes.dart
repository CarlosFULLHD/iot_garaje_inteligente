import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/views/login.dart';
import 'package:smartpark/views/signup.dart';
import 'package:smartpark/views/welcome_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case '/':
      default:
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthProvider>(
            builder: (ctx, authProvider, _) => authProvider.isAuthenticated
                ? WelcomeScreen()  // Cambiado a WelcomeScreen en lugar de HomeScreen
                : WelcomeScreen(), // Cambiado a WelcomeScreen en lugar de LoginScreen
          ),
        );
    }
  }
}
