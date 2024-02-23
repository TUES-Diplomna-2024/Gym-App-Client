import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:gym_app_client/pages/form_page.dart';
import 'package:gym_app_client/utils/forms/workout_edit_form.dart';

class WorkoutEditPage extends FormPage {
  WorkoutEditPage({
    super.key,
    required WorkoutViewModel workoutInitState,
    required void Function(String, String?, List<ExercisePreviewModel>?)
        onWorkoutUpdated,
  }) : super(
          title: "Edit Workout",
          form: WorkoutEditForm(
            workoutInitState: workoutInitState,
            onWorkoutUpdated: onWorkoutUpdated,
            padding:
                const EdgeInsets.only(top: 35, left: 25, right: 25, bottom: 25),
          ),
        );
}
