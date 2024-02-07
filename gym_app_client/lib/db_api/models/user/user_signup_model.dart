import 'dart:convert';

class UserSignUpModel {
  final String username;
  final String email;
  final String password;
  final String birthDate;
  final String gender;
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
        "gender": gender,
        "height": double.parse(height.toStringAsFixed(1)),
        "weight": double.parse(weight.toStringAsFixed(1)),
      });
}
