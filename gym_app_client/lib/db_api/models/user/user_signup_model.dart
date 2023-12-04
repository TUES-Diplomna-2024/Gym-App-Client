import 'dart:convert';

class UserSignUpModel {
  final String username;
  final String email;
  final String birthDate;
  final String password;

  UserSignUpModel({
    required this.username,
    required this.email,
    required this.birthDate,
    required this.password,
  });

  String toJson() => jsonEncode({
        "Username": username,
        "Email": email,
        "BirthDate": birthDate,
        "Password": password
      });
}
