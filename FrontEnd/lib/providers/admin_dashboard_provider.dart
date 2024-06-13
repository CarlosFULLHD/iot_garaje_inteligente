import 'package:flutter/material.dart';
import 'package:smartpark/models/spot_stats_model.dart';
import 'package:smartpark/services/services.dart';

class AdminDashboardProvider with ChangeNotifier {
  final Services _services = Services();

  Future<SpotStatsModel> fetchSpotStats(String spotId) async {
    try {
      return await _services.getSpotStats(spotId);
    } catch (e) {
      print('Error en fetchSpotStats: $e');
      rethrow;
    }
  }

  Future<List<ParkingStatsModel>> fetchAllSpotsStats() async {
    try {
      return await _services.getAllSpotsStats();
    } catch (e) {
      print('Error en fetchAllSpotsStats: $e');
      rethrow;
    }
  }
}
