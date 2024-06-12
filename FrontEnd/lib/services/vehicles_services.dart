import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartpark/models/user_activity_model.dart';
import 'package:smartpark/models/register_user_model.dart';
import 'package:smartpark/models/vehicles_model.dart';
import 'package:smartpark/services/services.dart';
import 'package:smartpark/utils/constants.dart';
import 'package:smartpark/utils/globals.dart';

class VehiclesServices {
  final _storage = const FlutterSecureStorage();
  final services = Services();

  Future<List<VehiclesModel>> getVehicles() async {
    final jwt = await _storage.read(key: Constants.ssToken);
    final data = await services.parseJwtPayLoad(jwt!);

    String url = '${Globals.url}/vehicles/${data['userId']}/vehicles';
    final response = await services.getHttp(url, 0);
    if (response.statusCode == 200) {
      return vehiclesModelFromJson(response.body);
    } else {
      return [];
    }
  }

  Future<bool> addVehicles(RegisterUserModel register) async {
    final jwt = await _storage.read(key: Constants.ssToken);
    final data = await services.parseJwtPayLoad(jwt!);
    register.idUsers = data['userId'];
    final url = '${Globals.url}/vehicles/register';
    final response = await services.postHttp(url, jsonEncode(register.toJson()), 0);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // Añadir este método para obtener los vehículos por usuario
  Future<List<UserActivityModel>> getUserVehicles(String userId) async {
    String url = '${Globals.url}/users/$userId/vehicles';
    final response = await services.getHttp(url, 0);
    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((model) => UserActivityModel.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load user vehicles');
    }
  }
}