import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';

class UnsignedIntFormField extends PaddedTextFormField {
  UnsignedIntFormField({
    super.key,
    required TextEditingController numberController,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    int? minValue,
    required EdgeInsets padding,
  }) : super(
          controller: numberController,
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
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "$label cannot be empty";
            } else if (minValue != null && int.parse(value) < minValue) {
              return "$label cannot be smaller than $minValue";
            }

            return null;
          },
        );
}
