import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';

class ExerciseVisibilityFormField
    extends PaddedDropdownButtonFormField<ExerciseVisibility> {
  ExerciseVisibilityFormField({
    super.key,
    required void Function(ExerciseVisibility?) onVisibilityChanged,
    required super.padding,
    ExerciseVisibility? defaultVisibility,
  }) : super(
          decoration: const InputDecoration(
            label: Text("Visibility"),
            filled: true,
            prefixIcon: Icon(Icons.remove_red_eye),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onVisibilityChanged,
          items: ExerciseVisibility.values
              .map((visibility) => DropdownMenuItem(
                    value: visibility,
                    child: Text(capitalizeFirstLetter(visibility.name)),
                  ))
              .toList(),
          defaultItem: defaultVisibility,
          validator: (ExerciseVisibility? value) => null,
        );
}
