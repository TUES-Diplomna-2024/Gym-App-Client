import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';

class ExerciseTypeFormField
    extends PaddedDropdownButtonFormField<ExerciseType> {
  ExerciseTypeFormField({
    super.key,
    ExerciseType? defaultType,
    required void Function(ExerciseType?) onTypeChanged,
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
          items: ExerciseType.values
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(capitalizeFirstLetter(type.name)),
                  ))
              .toList(),
          defaultItem: defaultType,
          validator: (ExerciseType? value) {
            if (value == null) {
              return "Please select exercise type";
            }

            return null;
          },
        );
}
