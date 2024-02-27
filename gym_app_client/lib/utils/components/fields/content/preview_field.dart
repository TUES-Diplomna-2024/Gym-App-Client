import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';

class PreviewField extends ContentField {
  const PreviewField({
    super.key,
    super.fieldName,
    required super.fieldValue,
    required super.padding,
  }) : super(
          valueOverflow: TextOverflow.ellipsis,
          decorationPadding: const EdgeInsets.all(8),
        );
}
