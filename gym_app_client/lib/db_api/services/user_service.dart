import 'package:gym_app_client/db_api/models/jwt_model.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signin_model.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';
import 'package:gym_app_client/db_api/services/jwt_service.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class UserService extends BaseService {
  final jwtService = JwtService();

  UserService() : super(baseEndpoint: "users");

  Future<(String msg, Color color)> signUp(UserSignUpModel user) async {
    try {
      final response = await post(
        getUri("signup"),
        headers: {"Content-Type": "application/json"},
        body: user.toJson(),
      );

      switch (response.statusCode) {
        case 200:
          final jwtResult = JwtModel.loadFromMap(json.decode(response.body));

          jwtService.saveJwtInStorage(jwtResult.jwt);

          return (
            "Your account has been successfully created!",
            Colors.green.shade300
          );
        case 400:
          return ("Invalid user data!", Colors.red.shade400);
        case 409:
          return ("This email address is already in use!", Colors.red.shade400);
        default:
          return (
            "Unexpected status code: ${response.statusCode}",
            Colors.red.shade400
          );
      }
    } catch (er) {
      return ("Error: ${er.toString()}", Colors.red.shade400);
    }
  }

  Future<(String msg, Color color)> signIn(UserSignInModel user) async {
    try {
      final response = await post(
        getUri("signin"),
        headers: {"Content-Type": "application/json"},
        body: user.toJson(),
      );

      switch (response.statusCode) {
        case 200:
          final jwtResult = JwtModel.loadFromMap(json.decode(response.body));

          await jwtService.saveJwtInStorage(jwtResult.jwt);

          final payload = await jwtService.getJwtPayload();
          String userId = payload!["userId"];

          return ("Hello, user with ID: $userId!", Colors.green.shade300);
        case 400:
          return ("Invalid user data!", Colors.red.shade400);
        case 401:
          return ("Sign in or password is invalid!", Colors.red.shade400);
        default:
          return (
            "Unexpected status code: ${response.statusCode}",
            Colors.red.shade400
          );
      }
    } catch (er) {
      return ("Error: ${er.toString()}", Colors.red.shade400);
    }
  }
}
