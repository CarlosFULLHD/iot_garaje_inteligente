import 'package:flutter/material.dart';
import 'package:smartpark/models/user_activity_model.dart';
import 'package:smartpark/services/vehicles_services.dart';

class VehicleActivityProvider with ChangeNotifier {
  final VehiclesServices _vehiclesServices = VehiclesServices();

  Future<List<UserActivityModel>> fetchVehicleActivity(String userId) async {
    try {
      return await _vehiclesServices.getUserVehicles(userId);
    } catch (e) {
      print('Error en fetchVehicleActivity: $e');
      rethrow;
    }
  }
}
