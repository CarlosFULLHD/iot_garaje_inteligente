// To parse this JSON data, do
//
//     final vehiclesModel = vehiclesModelFromJson(jsonString);

import 'dart:convert';

List<VehiclesModel> vehiclesModelFromJson(String str) => List<VehiclesModel>.from(json.decode(str).map((x) => VehiclesModel.fromJson(x)));

String vehiclesModelToJson(List<VehiclesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehiclesModel {
  int? idVehicles;
  dynamic userId;
  String? licensePlate;
  String? carBranch;
  String? carModel;
  String? carColor;
  String? carManufacturingDate;
  dynamic createdAt;
  dynamic updatedAt;

  VehiclesModel({
    this.idVehicles,
    this.userId,
    this.licensePlate,
    this.carBranch,
    this.carModel,
    this.carColor,
    this.carManufacturingDate,
    this.createdAt,
    this.updatedAt,
  });

  factory VehiclesModel.fromJson(Map<String, dynamic> json) => VehiclesModel(
    idVehicles: json["idVehicles"],
    userId: json["userId"],
    licensePlate: json["licensePlate"],
    carBranch: json["carBranch"],
    carModel: json["carModel"],
    carColor: json["carColor"],
    carManufacturingDate: json["carManufacturingDate"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "idVehicles": idVehicles,
    "userId": userId,
    "licensePlate": licensePlate,
    "carBranch": carBranch,
    "carModel": carModel,
    "carColor": carColor,
    "carManufacturingDate": carManufacturingDate,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
