import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/gender.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';

class GenderFormField extends PaddedDropdownButtonFormField<Gender> {
  GenderFormField({
    super.key,
    Gender? defaultGender,
    required void Function(Gender?) onGenderChanged,
    required super.padding,
  }) : super(
          decoration: const InputDecoration(
            label: Text("Gender"),
            filled: true,
            prefixIcon: Icon(Icons.accessibility_new_outlined),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onGenderChanged,
          items: Gender.values
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(capitalizeFirstLetter(gender.name)),
                  ))
              .toList(),
          defaultItem: defaultGender,
          validator: (Gender? value) {
            if (value == null) {
              return "Please select your gender";
            }

            return null;
          },
        );
}
