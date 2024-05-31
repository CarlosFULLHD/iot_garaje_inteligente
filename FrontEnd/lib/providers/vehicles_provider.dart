import 'package:flutter/material.dart';
import 'package:smartpark/models/vehicles_model.dart';
import 'package:smartpark/services/vehicles_services.dart';

class VehiclesProvider extends ChangeNotifier {
  Future<List<VehiclesModel>> getVehicles() async {
    return VehiclesServices().getVehicles();
  }
}