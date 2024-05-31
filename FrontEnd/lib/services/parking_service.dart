import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/models/spots_model.dart';
import 'package:smartpark/services/services.dart';
import 'package:smartpark/utils/globals.dart';

class ParkingService {
  final services = Services();

  Future<List<ParkingModel>> getParkings() async {
    String url = '${Globals.url}/parkings';
    final response = await services.getHttp(url, 0);
    if(response.statusCode == 200){
      return parkingModelFromJson(response.body);
    }else{
      return [];
    }
  }

    Future<List<SpotsModel>> getParkingsById(int parkingId) async {
    String url = '${Globals.url}/parkings/$parkingId/spots';
    final response = await services.getHttp(url, 0);
    if(response.statusCode == 200){
      return spotsModelFromJson(response.body);
    }else{
      return [];
    }
  }
}