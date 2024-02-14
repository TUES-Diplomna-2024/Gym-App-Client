import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';

class ExerciseDifficultyFormField
    extends PaddedDropdownButtonFormField<String> {
  ExerciseDifficultyFormField({
    super.key,
    String? defaultDifficulty,
    required void Function(String?) onDifficultyChanged,
    required EdgeInsets padding,
  }) : super(
          padding: padding,
          decoration: const InputDecoration(
            label: Text("Difficulty"),
            filled: true,
            prefixIcon: Icon(Icons.bolt_outlined),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onDifficultyChanged,
          items: ExerciseConstants.difficulties
              .map((String difficulty) => DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty),
                  ))
              .toList(),
          defaultItem: defaultDifficulty,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please select exercise difficulty";
            }

            return null;
          },
        );
}
