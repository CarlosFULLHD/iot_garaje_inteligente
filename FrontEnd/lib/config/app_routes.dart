// lib/config/routes.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/views/home_screen.dart';
import 'package:smartpark/views/login_screen.dart';


class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/':
      default:
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthProvider>(
            builder: (ctx, authProvider, _) => authProvider.isAuthenticated
                ? HomeScreen()
                : LoginScreen(),
          ),
        );
    }
  }
}
