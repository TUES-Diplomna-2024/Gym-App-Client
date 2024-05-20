import 'dart:convert';
import 'package:gym_app_client/utils/common/enums/gender.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class UserSignUpModel {
  final String username;
  final String email;
  final String password;
  final String birthDate;
  final Gender gender;
  final double height;
  final double weight;

  UserSignUpModel({
    required this.username,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
  });

  String toJson() => jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "birthDate": birthDate,
        "gender": gender.index,
        "height": normalizeDouble(height),
        "weight": normalizeDouble(weight),
      });
}
