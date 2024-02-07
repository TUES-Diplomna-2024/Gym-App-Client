import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/profile/profile_field.dart';
import 'package:intl/intl.dart';

class ProfileDateField extends ProfileField {
  ProfileDateField({
    super.key,
    required IconData dateIcon,
    required String dateName,
    required String dateValue,
    required EdgeInsets padding,
  }) : super(
          fieldIcon: dateIcon,
          fieldName: dateName,
          fieldValue: _formatDate(dateValue),
          padding: padding,
        );

  static String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    return formattedDate;
  }
}
