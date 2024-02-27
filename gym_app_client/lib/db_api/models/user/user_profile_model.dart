import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

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
    roleColor = hexToColor(body["roleColor"]);

    gender = capitalizeFirstLetter(body["gender"]);

    height = normalizeDouble(body["height"]);
    weight = normalizeDouble(body["weight"]);

    birthDate = body["birthDate"];
    onCreated = body["onCreated"];
  }

  void updateProfile(UserUpdateModel updateModel) {
    username = updateModel.username;
    birthDate = updateModel.birthDate;
    gender = updateModel.gender;
    height = normalizeDouble(updateModel.height);
    weight = normalizeDouble(updateModel.weight);
  }
}
