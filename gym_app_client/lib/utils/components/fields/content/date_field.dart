import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class DateField extends ContentField {
  DateField({
    super.key,
    required IconData dateIcon,
    required String dateName,
    required String dateValue,
    required super.padding,
  }) : super(
          fieldIcon: dateIcon,
          fieldName: dateName,
          fieldValue: normalizeDateString(dateValue),
        );
}
