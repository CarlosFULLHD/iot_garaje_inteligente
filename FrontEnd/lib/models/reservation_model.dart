// To parse this JSON data, do
//
//     final reservationModel = reservationModelFromJson(jsonString);

import 'dart:convert';

ReservationModel reservationModelFromJson(String str) => ReservationModel.fromJson(json.decode(str));

String reservationModelToJson(ReservationModel data) => json.encode(data.toJson());

class ReservationModel {
    int? userId;
    int? vehicleId;
    int? spotId;
    DateTime? scheduledEntry;
    DateTime? scheduledExit;

    ReservationModel({
        this.userId,
        this.vehicleId,
        this.spotId,
        this.scheduledEntry,
        this.scheduledExit,
    });

    factory ReservationModel.fromJson(Map<String, dynamic> json) => ReservationModel(
        userId: json["userId"],
        vehicleId: json["vehicleId"],
        spotId: json["spotId"],
        scheduledEntry: json["scheduledEntry"] == null ? null : DateTime.parse(json["scheduledEntry"]),
        scheduledExit: json["scheduledExit"] == null ? null : DateTime.parse(json["scheduledExit"]),
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "vehicleId": vehicleId,
        "spotId": spotId,
        "scheduledEntry": scheduledEntry?.toIso8601String(),
        "scheduledExit": scheduledExit?.toIso8601String(),
    };
}
