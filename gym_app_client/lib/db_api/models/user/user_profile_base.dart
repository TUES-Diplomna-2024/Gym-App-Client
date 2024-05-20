import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/gender.dart';

abstract class UserProfileBase {
  String get id;
  String get email;
  String get roleName;
  Color get roleColor;
  String get onCreated;
  String get username;
  String get birthDate;
  Gender get gender;
  double get height;
  double get weight;
}
