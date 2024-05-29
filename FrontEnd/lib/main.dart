import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/config/app_routes.dart'; // Asegúrate de que la ruta es correcta
import 'package:smartpark/style/colors.dart';
import 'package:smartpark/providers/auth_provider.dart';

import 'utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: Constants.appName,
        theme: ThemeData(
          primarySwatch: AppColors.primaryColor,
        ),
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: '/',  // Aquí se establece la pantalla inicial
      ),
    );
  }
}
