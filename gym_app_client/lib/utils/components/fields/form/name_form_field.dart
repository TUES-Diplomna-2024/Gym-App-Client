import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';

class NameFormField extends PaddedTextFormField {
  NameFormField({
    super.key,
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required int minLength,
    required int maxLength,
    required void Function(String) onChanged,
    required EdgeInsets padding,
  }) : super(
          controller: controller,
          padding: padding,
          decoration: InputDecoration(
            label: Text(label),
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
              return "$label cannot be empty";
            } else if (value.length < minLength || value.length > maxLength) {
              return "$label must be between $minLength and $maxLength characters";
            }

            onChanged(value);
            return null;
          },
        );
}
