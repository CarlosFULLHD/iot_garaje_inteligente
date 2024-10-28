import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/models/spots_model.dart';
import 'package:smartpark/services/parking_service.dart';
import 'package:smartpark/utils/constants.dart';
import 'package:smartpark/views/space_view.dart';
import 'package:smartpark/views/vehicles_view.dart';


class ParkingProvider with ChangeNotifier {
  List<Spot> leftSpots = [];
  List<Spot> rightSpots = [];
  bool isLoading = false;

  Future<void> loadSpots(int parkingId) async {
    isLoading = true;
    notifyListeners();

    try {
      final spotsData = await ParkingService.fetchGroupedSpots(parkingId);
      leftSpots = spotsData['leftSpots']!;
      rightSpots = spotsData['rightSpots']!;
    } catch (error) {
      print('Error al cargar los espacios: $error');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> makeReservation(int spotId) async {
    try {
      await ParkingService.makeReservation(spotId);
      notifyListeners();
    } catch (error) {
      print('Error al hacer la reserva: $error');
    }
  }
}
