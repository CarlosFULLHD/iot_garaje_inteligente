import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/models/spots_model.dart';
import 'package:smartpark/services/parking_service.dart';
import 'package:smartpark/utils/constants.dart';
import 'package:smartpark/views/space_view.dart';
import 'package:smartpark/views/vehicles_view.dart';

class ParkingProvider extends ChangeNotifier {
  ParkingProvider() {
    getName();
  }

 String? _name;
  String? get name => _name;
  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  void getName() {
    // securitystorage
    final _storage = const FlutterSecureStorage();
    _storage.read(key: Constants.ssName).then((value) {
      _name = value;
    });
  
  }
  get vehicles => null;

  Future<List<ParkingModel>> getParkings() async {
    return ParkingService().getParkings();
  }

  Future<List<SpotsModel>> getParkingsById(parkingId) async {
    return ParkingService().getParkingsById(parkingId);
  }

  void goToVehicle(BuildContext context) {
    context.pushNamed(VehiclesView.routerName);
  }

  void goSpaces(BuildContext context, ParkingModel parking) {
    context.pushNamed(SpaceView.routerName, extra: {'parking': parking});
  }
}