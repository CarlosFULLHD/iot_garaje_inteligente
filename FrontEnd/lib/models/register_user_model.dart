// To parse this JSON data, do
//
//     final registerUserModel = registerUserModelFromJson(jsonString);

import 'dart:convert';

RegisterUserModel registerUserModelFromJson(String str) => RegisterUserModel.fromJson(json.decode(str));

String registerUserModelToJson(RegisterUserModel data) => json.encode(data.toJson());

class RegisterUserModel {
  String? name;
  String? lastName;
  String? email;
  String? password;
  String? pinCode;
  String? licensePlate;
  String? carBranch;
  String? carModel;
  String? carColor;
  String? carManufacturingDate;

  RegisterUserModel({
    this.name,
    this.lastName,
    this.email,
    this.password,
    this.pinCode,
    this.licensePlate,
    this.carBranch,
    this.carModel,
    this.carColor,
    this.carManufacturingDate,
  });

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) => RegisterUserModel(
    name: json["name"],
    lastName: json["lastName"],
    email: json["email"],
    password: json["password"],
    pinCode: json["pinCode"],
    licensePlate: json["licensePlate"],
    carBranch: json["carBranch"],
    carModel: json["carModel"],
    carColor: json["carColor"],
    carManufacturingDate: json["carManufacturingDate"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lastName": lastName,
    "email": email,
    "password": password,
    "pinCode": pinCode,
    "licensePlate": licensePlate,
    "carBranch": carBranch,
    "carModel": carModel,
    "carColor": carColor,
    "carManufacturingDate": carManufacturingDate,
  };
}
