// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:smartpark/models/usar.dart';
import 'package:smartpark/services/auth_services.dart';


class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    _user = await AuthService.login(email, password);

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
