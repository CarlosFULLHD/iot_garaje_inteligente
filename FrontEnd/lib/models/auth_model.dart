// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  String? username;
  String? message;
  bool? status;
  String? jwt;
  String? userId;  // Añadir esta línea

  AuthModel({
    this.username,
    this.message,
    this.status,
    this.jwt,
    this.userId,  // Añadir esta línea
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    username: json["username"],
    message: json["message"],
    status: json["status"],
    jwt: json["jwt"],
    userId: json["userId"],  // Añadir esta línea
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "message": message,
    "status": status,
    "jwt": jwt,
    "userId": userId,  // Añadir esta línea
  };
}
