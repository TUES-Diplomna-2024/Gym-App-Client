import 'dart:convert';
import 'package:http/http.dart';

class UserProfileModel {
  late final String id;
  late final String username;
  late final String email;

  late final String roleName;
  late final String roleColor;

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
    roleColor = body["roleName"];

    gender = body["gender"];
    height = body["height"].toDouble();
    weight = body["weight"].toDouble();

    birthDate = body["birthDate"];
    onCreated = body["onCreated"];
  }
}
