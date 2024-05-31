// To parse this JSON data, do
//
//     final parkingModel = parkingModelFromJson(jsonString);

import 'dart:convert';

List<ParkingModel> parkingModelFromJson(String str) => List<ParkingModel>.from(json.decode(str).map((x) => ParkingModel.fromJson(x)));

String parkingModelToJson(List<ParkingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParkingModel {
    int? idPar;
    String? name;
    String? location;
    int? totalSpots;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<Spot>? spots;

    ParkingModel({
        this.idPar,
        this.name,
        this.location,
        this.totalSpots,
        this.createdAt,
        this.updatedAt,
        this.spots,
    });

    factory ParkingModel.fromJson(Map<String, dynamic> json) => ParkingModel(
        idPar: json["idPar"],
        name: json["name"],
        location: json["location"],
        totalSpots: json["totalSpots"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        spots: json["spots"] == null ? [] : List<Spot>.from(json["spots"]!.map((x) => Spot.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idPar": idPar,
        "name": name,
        "location": location,
        "totalSpots": totalSpots,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "spots": spots == null ? [] : List<dynamic>.from(spots!.map((x) => x.toJson())),
    };
}

class Spot {
    int? idSpots;
    int? spotNumber;
    int? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    Spot({
        this.idSpots,
        this.spotNumber,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Spot.fromJson(Map<String, dynamic> json) => Spot(
        idSpots: json["idSpots"],
        spotNumber: json["spotNumber"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "idSpots": idSpots,
        "spotNumber": spotNumber,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
