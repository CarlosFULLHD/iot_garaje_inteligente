import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/services/parking_service.dart';
import 'package:smartpark/views/space_view.dart';
import 'package:smartpark/views/vehicles_view.dart';

class ParkingProvider extends ChangeNotifier {
  Future<List<ParkingModel>> getParkings() async {
    return ParkingService().getParkings();
  }

  void goToVehicle(BuildContext context) {
    context.pushNamed(VehiclesView.routerName);
  }

  void goSpaces(BuildContext context, ParkingModel parking) {
    context.pushNamed(SpaceView.routerName, extra: {'parking': parking});
  }
}