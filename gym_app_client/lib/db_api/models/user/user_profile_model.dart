import 'dart:convert';
import 'package:gym_app_client/db_api/models/user/user_profile_base.dart';
import 'package:gym_app_client/utils/common/enums/gender.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class UserProfileModel implements UserProfileBase {
  @override
  late final String id;
  @override
  late final String email;
  @override
  late final String roleName;
  @override
  late final Color roleColor;
  @override
  late final String onCreated;
  @override
  late final String username;
  @override
  late final String birthDate;
  @override
  late final Gender gender;
  @override
  late final double height;
  @override
  late final double weight;

  UserProfileModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    id = body["id"];
    username = body["username"];
    email = body["email"];

    roleName = body["roleName"];
    roleColor = hexToColor(body["roleColor"]);

    gender = Gender.values[body["gender"]];
    height = normalizeDouble(body["height"]);
    weight = normalizeDouble(body["weight"]);
    birthDate = body["birthDate"];
    onCreated = body["onCreated"];
  }
}
