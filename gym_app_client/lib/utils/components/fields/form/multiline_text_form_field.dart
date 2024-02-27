import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';

class MultilineTextFormField extends PaddedTextFormField {
  MultilineTextFormField({
    super.key,
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    int? minLength,
    int? maxLength,
    bool isOptional = false,
    required super.padding,
  }) : super(
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(
            label: Text("$label${isOptional ? ' (Optional)' : ''}"),
            prefixIcon: Icon(prefixIcon),
            hintText: hintText,
            filled: true,
            enabledBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return isOptional ? null : "$label cannot be empty";
            } else if (minLength != null && value.length < minLength) {
              return "$label must be longer than $minLength characters";
            } else if (maxLength != null && value.length > maxLength) {
              return "$label must be up to $maxLength characters long";
            }

            return null;
          },
        );
}
