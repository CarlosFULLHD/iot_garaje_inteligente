// lib/services/auth_service.dart

import 'package:smartpark/models/usar.dart';



class AuthService {
  static Future<User?> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simula la llamada a un servicio

    // Aquí iría la lógica real de autenticación
    // Por ejemplo, haciendo una petición HTTP a un servidor

    return User(id: '1', email: email);
  }
}
