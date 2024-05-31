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

  AuthModel({
    this.username,
    this.message,
    this.status,
    this.jwt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    username: json["username"],
    message: json["message"],
    status: json["status"],
    jwt: json["jwt"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "message": message,
    "status": status,
    "jwt": jwt,
  };
}
