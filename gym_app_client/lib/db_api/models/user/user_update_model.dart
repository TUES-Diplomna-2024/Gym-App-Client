import 'dart:convert';

class UserUpdateModel {
  late final String username;
  late final String birthDate;
  late final String gender;
  late final double height;
  late final double weight;

  UserUpdateModel({
    required this.username,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
  });

  String toJson() => jsonEncode({
        "username": username,
        "birthDate": birthDate,
        "gender": gender,
        "height": height,
        "weight": weight,
      });
}