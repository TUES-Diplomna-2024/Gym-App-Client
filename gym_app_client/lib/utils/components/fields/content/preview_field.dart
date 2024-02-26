import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';

class PreviewField extends ContentField {
  const PreviewField({
    super.key,
    String? fieldName,
    required dynamic fieldValue,
    required EdgeInsets padding,
  }) : super(
          fieldName: fieldName,
          fieldValue: fieldValue,
          padding: padding,
          valueOverflow: TextOverflow.ellipsis,
          decorationPadding: const EdgeInsets.all(8),
        );
}
