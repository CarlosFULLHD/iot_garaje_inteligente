// To parse this JSON data, do
//
//     final spotsModel = spotsModelFromJson(jsonString);

import 'dart:convert';

List<SpotsModel> spotsModelFromJson(String str) => List<SpotsModel>.from(json.decode(str).map((x) => SpotsModel.fromJson(x)));

String spotsModelToJson(List<SpotsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Spot {
  final int idSpots;
  final int parkingId;
  final int spotNumber;
  final int status;
  final DateTime updatedAt;

  Spot({
    required this.idSpots,
    required this.parkingId,
    required this.spotNumber,
    required this.status,
    required this.updatedAt,
  });

  // Método para convertir desde JSON
  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      idSpots: json['idSpots'],
      parkingId: json['parkingId'],
      spotNumber: json['spotNumber'],
      status: json['status'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
