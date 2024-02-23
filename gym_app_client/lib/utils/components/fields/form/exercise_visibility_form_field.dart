import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';

class ExerciseVisibilityFormField extends PaddedDropdownButtonFormField<bool> {
  ExerciseVisibilityFormField({
    super.key,
    required bool defaultVisibility,
    required void Function(bool?) onVisibilityChanged,
    required EdgeInsets padding,
  }) : super(
          padding: padding,
          decoration: const InputDecoration(
            label: Text("Visibility"),
            filled: true,
            prefixIcon: Icon(Icons.remove_red_eye),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onVisibilityChanged,
          items: const [
            DropdownMenuItem(
              value: ExerciseConstants.publicVisibility,
              child: Text("Public"),
            ),
            DropdownMenuItem(
              value: ExerciseConstants.privateVisibility,
              child: Text("Private"),
            ),
          ],
          defaultItem: defaultVisibility,
          validator: (bool? value) => null,
        );
}
