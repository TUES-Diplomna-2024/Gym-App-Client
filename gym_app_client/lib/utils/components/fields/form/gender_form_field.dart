import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';

class GenderFormField extends PaddedDropdownButtonFormField<String> {
  GenderFormField({
    super.key,
    String? defaultGender,
    required void Function(String?) onGenderChanged,
    required EdgeInsets padding,
  }) : super(
          padding: padding,
          decoration: const InputDecoration(
            label: Text("Gender"),
            filled: true,
            prefixIcon: Icon(Icons.accessibility_new_outlined),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onGenderChanged,
          items: UserConstants.genders
              .map((String gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
          defaultItem: defaultGender,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please select your gender";
            }

            return null;
          },
        );
}
