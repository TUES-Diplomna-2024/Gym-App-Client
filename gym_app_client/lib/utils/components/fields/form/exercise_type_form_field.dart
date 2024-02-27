import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';

class ExerciseTypeFormField extends PaddedDropdownButtonFormField<String> {
  ExerciseTypeFormField({
    super.key,
    String? defaultType,
    required void Function(String?) onTypeChanged,
    required super.padding,
  }) : super(
          decoration: const InputDecoration(
            label: Text("Type"),
            filled: true,
            prefixIcon: Icon(Icons.sports_gymnastics_outlined),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onTypeChanged,
          items: ExerciseConstants.types
              .map((String type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          defaultItem: defaultType,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please select exercise type";
            }

            return null;
          },
        );
}
