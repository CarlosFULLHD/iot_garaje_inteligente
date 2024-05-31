import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    if(response.statusCode == 200){
      return vehiclesModelFromJson(response.body);
    }else{
      return [];
    }
  }
}