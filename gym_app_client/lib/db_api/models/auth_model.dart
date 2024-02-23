import 'dart:convert';
import 'package:http/http.dart';

class AuthModel {
  late final String accessToken;
  late final String refreshToken;

  AuthModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    accessToken = body["accessToken"];
    refreshToken = body["refreshToken"];
  }
}
