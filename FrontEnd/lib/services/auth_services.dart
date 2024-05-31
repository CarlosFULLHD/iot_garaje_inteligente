import 'dart:convert';

import 'package:smartpark/models/auth_model.dart';
import 'package:smartpark/models/register_user_model.dart';
import 'package:smartpark/services/services.dart';
import 'package:smartpark/utils/globals.dart';

class AuthService {
  final services = Services();

  Future<AuthModel> login(String email, String password) async {
    String url = '${Globals.url}/users/login';
    final response = await services.postHttp(url, jsonEncode({'username': email, 'password': password}), 0);
    if(response.statusCode == 200){
      return AuthModel.fromJson(jsonDecode(response.body));
    }else{
      return AuthModel();
    }
  }

  Future<bool> registerUser(RegisterUserModel registerUser) async {
    String url = '${Globals.url}/users/register';
    final response = await services.postHttp(url, jsonEncode(registerUser.toJson()), 0);
    if(response.statusCode == 201){
      return true;
    }else{
      return false;
    }
  }
}
