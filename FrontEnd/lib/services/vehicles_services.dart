import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartpark/models/register_user_model.dart';
import 'package:smartpark/models/vehicles_model.dart';
import 'package:smartpark/services/services.dart';
import 'package:smartpark/utils/constants.dart';
import 'package:smartpark/utils/globals.dart';

class VehiclesServices {
  final _storage = const FlutterSecureStorage();
  final services = Services();
    //  obtniendo los vehiculos por usuario de 15 a 18
  
  Future<List<VehiclesModel>> getVehicles() async {
    final jwt = await _storage.read(key: Constants.ssToken);
    final data = await services.parseJwtPayLoad(jwt!);

    String url = '${Globals.url}/vehicles/${data['userId']}/vehicles';
    final response = await services.getHttp(url, 0);
    if(response.statusCode == 200){
      return vehiclesModelFromJson(response.body);
    }else{
      return [];
    }
  }

  Future<bool> addVehicles(RegisterUserModel register) async {
    final jwt = await _storage.read(key: Constants.ssToken);
    final data = await services.parseJwtPayLoad(jwt!);
    register.idUsers = data['userId'];
    final url = '${Globals.url}/vehicles/register';
    final response = await services.postHttp(url, jsonEncode(register.toJson()), 0);
    if(response.statusCode == 201){
      return true;
    }else{
      return false;
    }
  }

  // Obtner los vehiculos por usuario
  
}