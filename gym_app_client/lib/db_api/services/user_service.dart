import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signin_model.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class UserService extends BaseService {
  UserService()
      : super(baseEndpoint: "users", subEndpoints: ["signup", "signin"]);

  Future<(String msg, Color color)> signUp(UserSignUpModel user) async {
    try {
      final response = await post(
        urls[0],
        headers: {"Content-Type": "application/json"},
        body: user.toJson(),
      );

      switch (response.statusCode) {
        case 200:
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
    return ("", Colors.cyan);
  }
}
