import 'package:gym_app_client/utils/common/date_only.dart';

class UserProfileModel {
  late final String id;
  late final String username;
  late final String email;
  late final DateOnly birthDate;
  late final DateOnly onCreated;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.birthDate,
    required this.onCreated,
  });

  UserProfileModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"] as String;
    username = data["username"] as String;
    email = data["email"] as String;
    birthDate = DateOnly.fromString(data["birthDate"] as String);
    onCreated = DateOnly.fromString(data["onCreated"] as String);
  }
}
