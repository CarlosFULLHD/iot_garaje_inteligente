// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/config/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: AppRoutes.providers,
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SmartPark',
      routerConfig: AppRoutes.router,
    );
  }
}