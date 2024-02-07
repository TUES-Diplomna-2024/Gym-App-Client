import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

class UserProfileModel {
  late final String id;
  late final String username;
  late final String email;

  late final String roleName;
  late final Color roleColor;

  late final String gender;
  late final double height;
  late final double weight;

  late final String birthDate;
  late final String onCreated;

  UserProfileModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    id = body["id"];
    username = body["username"];
    email = body["email"];

    roleName = body["roleName"];
    roleColor = _getColor(body["roleColor"]);

    gender = body["gender"];
    height = double.parse(body["height"].toStringAsFixed(1));
    weight = double.parse(body["weight"].toStringAsFixed(1));

    birthDate = body["birthDate"];
    onCreated = body["onCreated"];
  }

  Color _getColor(String hexColor) {
    if (hexColor.startsWith('#')) hexColor = hexColor.substring(1);
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    return Color(int.parse(hexColor, radix: 16));
  }
}
