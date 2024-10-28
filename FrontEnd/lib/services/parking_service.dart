import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/models/spots_model.dart';
import 'package:smartpark/services/services.dart';
import 'package:smartpark/utils/globals.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/spots_model.dart';
import '../globals.dart';

class ParkingService {
  static Future<Map<String, List<Spot>>> fetchGroupedSpots(int parkingId) async {
    final response = await http.get(Uri.parse('$baseUrl/parkings/$parkingId/groupedSpots'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<Spot> leftSpots = (data['leftSpots'] as List)
          .map((json) => Spot.fromJson(json))
          .toList();

      List<Spot> rightSpots = (data['rightSpots'] as List)
          .map((json) => Spot.fromJson(json))
          .toList();

      return {
        'leftSpots': leftSpots,
        'rightSpots': rightSpots,
      };
    } else {
      throw Exception('Error al cargar los espacios de estacionamiento');
    }
  }

  static Future<void> makeReservation(int spotId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/parkings/reservations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'spotId': spotId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al realizar la reserva');
    }
  }
}
