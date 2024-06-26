import 'dart:convert';

class UserSignInModel {
  final String email;
  final String password;

  UserSignInModel({
    required this.email,
    required this.password,
  });

  String toJson() => jsonEncode({
        "email": email,
        "password": password,
      });
}
