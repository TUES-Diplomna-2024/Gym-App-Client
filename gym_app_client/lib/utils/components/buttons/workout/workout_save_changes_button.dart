import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_update_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';

class WorkoutSaveChangesButton extends StatelessWidget {
  final _userService = UserService();
  final _workoutService = WorkoutService();

  final GlobalKey<FormState> formKey;

  final String workoutId;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final List<ExercisePreviewModel>? exercises;

  final void Function(String, String?, List<ExercisePreviewModel>?)
      onWorkoutUpdated;

  WorkoutSaveChangesButton({
    super.key,
    required this.formKey,
    required this.workoutId,
    required this.nameController,
    required this.descriptionController,
    required this.exercises,
    required this.onWorkoutUpdated,
  });

  void _handleWorkoutUpdate(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      var workoutUpdate = WorkoutUpdateModel(
        name: nameController.text,
        description: descriptionController.text.isEmpty
            ? null
            : descriptionController.text,
        exercisesIds: _getExercisesIds(),
      );

      _workoutService.updateWorkoutById(workoutId, workoutUpdate).then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.isSuccessful) {
            onWorkoutUpdated(
              workoutUpdate.name,
              workoutUpdate.description,
              exercises,
            );

            if (context.mounted) Navigator.of(context).pop();
          } else if (serviceResult.shouldSignOutUser) {
            _userService.signOut(context);
          }
        },
      );
    }
  }

  List<String>? _getExercisesIds() {
    if (exercises == null || exercises!.isEmpty) return null;

    return exercises!.map((e) => e.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: FloatingActionButton.extended(
        onPressed: () => _handleWorkoutUpdate(context),
        backgroundColor: Colors.lightGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        label: const Text("Save Changes"),
      ),
    );
  }
}
