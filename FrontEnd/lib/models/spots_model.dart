// To parse this JSON data, do
//
//     final spotsModel = spotsModelFromJson(jsonString);

import 'dart:convert';

List<SpotsModel> spotsModelFromJson(String str) => List<SpotsModel>.from(json.decode(str).map((x) => SpotsModel.fromJson(x)));

String spotsModelToJson(List<SpotsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpotsModel {
    int? idSpots;
    int? parkingId;
    int? spotNumber;
    int? status;
    DateTime? updatedAt;

    SpotsModel({
        this.idSpots,
        this.parkingId,
        this.spotNumber,
        this.status,
        this.updatedAt,
    });

    factory SpotsModel.fromJson(Map<String, dynamic> json) => SpotsModel(
        idSpots: json["idSpots"],
        parkingId: json["parkingId"],
        spotNumber: json["spotNumber"],
        status: json["status"],
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "idSpots": idSpots,
        "parkingId": parkingId,
        "spotNumber": spotNumber,
        "status": status,
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
