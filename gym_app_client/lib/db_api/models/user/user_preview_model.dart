import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class UserPreviewModel {
  late final String id;
  late final String username;
  late final String email;
  late final Color roleColor;
  late final String onCreated;

  UserPreviewModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"];
    username = data["username"];
    email = data["email"];
    roleColor = hexToColor(data["roleColor"]);
    onCreated = data["onCreated"];
  }

  static List<UserPreviewModel> getUserPreviewsFromResponse(Response response) {
    List<dynamic> body = json.decode(response.body);

    return getUserPreviewsFromBody(body);
  }

  static List<UserPreviewModel> getUserPreviewsFromBody(List<dynamic> body) {
    return List<UserPreviewModel>.from(
        body.map((e) => UserPreviewModel.loadFromMap(e)));
  }
}
