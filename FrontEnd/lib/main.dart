import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/config/app_routes.dart';
import 'package:smartpark/providers/auth_provider.dart';
import 'package:smartpark/providers/parking_provider.dart';
import 'package:smartpark/providers/reservation_provider.dart';
import 'package:smartpark/providers/vehicles_provider.dart';
import 'package:smartpark/providers/activity_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ParkingProvider()),
        ChangeNotifierProvider(create: (_) => VehiclesProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      
      ],
      child: const MyApp(),
    ),
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