import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';

class ExerciseDifficultyFormField
    extends PaddedDropdownButtonFormField<ExerciseDifficulty> {
  ExerciseDifficultyFormField({
    super.key,
    ExerciseDifficulty? defaultDifficulty,
    required void Function(ExerciseDifficulty?) onDifficultyChanged,
    required super.padding,
  }) : super(
          decoration: const InputDecoration(
            label: Text("Difficulty"),
            filled: true,
            prefixIcon: Icon(Icons.bolt_outlined),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onDifficultyChanged,
          items: ExerciseDifficulty.values
              .map((difficulty) => DropdownMenuItem(
                    value: difficulty,
                    child: Text(capitalizeFirstLetter(difficulty.name)),
                  ))
              .toList(),
          defaultItem: defaultDifficulty,
          validator: (ExerciseDifficulty? value) {
            if (value == null) {
              return "Please select exercise difficulty";
            }

            return null;
          },
        );
}
