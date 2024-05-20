import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/pages/form_page.dart';
import 'package:gym_app_client/utils/forms/exercise_edit_form.dart';

class ExerciseEditPage extends FormPage {
  ExerciseEditPage({
    super.key,
    required ExerciseViewModel exerciseInitState,
    required void Function() onUpdate,
  }) : super(
          title: "Edit Exercise",
          form: ExerciseEditForm(
            exerciseInitState: exerciseInitState,
            onUpdate: onUpdate,
            padding:
                const EdgeInsets.only(top: 35, left: 25, right: 25, bottom: 25),
          ),
        );
}
