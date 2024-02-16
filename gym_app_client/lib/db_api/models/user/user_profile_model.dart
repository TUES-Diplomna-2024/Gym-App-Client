import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'dart:convert';
import 'package:http/http.dart';

class UserProfileModel {
  late final String id;
  late final String email;
  late final String roleName;
  late final Color roleColor;
  late final String onCreated;

  late String username;
  late String birthDate;
  late String gender;
  late double height;
  late double weight;

  UserProfileModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    id = body["id"];
    username = body["username"];
    email = body["email"];

    roleName = body["roleName"];
    roleColor = _getColor(body["roleColor"]);

    gender = _normalizeData(body["gender"]);

    height = double.parse(body["height"].toStringAsFixed(1));
    weight = double.parse(body["weight"].toStringAsFixed(1));

    birthDate = body["birthDate"];
    onCreated = body["onCreated"];
  }

  void updateProfile(UserUpdateModel updateModel) {
    username = updateModel.username;
    birthDate = updateModel.birthDate;
    gender = updateModel.gender;
    height = double.parse(updateModel.height.toStringAsFixed(1));
    weight = double.parse(updateModel.weight.toStringAsFixed(1));
  }

  Color _getColor(String hexColor) {
    if (hexColor.startsWith('#')) hexColor = hexColor.substring(1);
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    return Color(int.parse(hexColor, radix: 16));
  }

  String _normalizeData(String data) =>
      "${data[0].toUpperCase()}${data.substring(1)}";
}
