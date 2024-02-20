import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';

class ExerciseAddInWorkoutDoneButton extends StatelessWidget {
  final _userService = UserService();
  final _exerciseService = ExerciseService();
  final String exerciseId;
  final List<String> selectedWorkoutIds;

  ExerciseAddInWorkoutDoneButton({
    super.key,
    required this.exerciseId,
    required this.selectedWorkoutIds,
  });

  void _handleExerciseAddedInWorkouts(BuildContext context) {
    if (selectedWorkoutIds.isEmpty) return;

    _exerciseService.addExerciseInWorkouts(exerciseId, selectedWorkoutIds).then(
      (serviceResult) {
        serviceResult.showPopUp(context);

        if (serviceResult.isSuccessful && context.mounted) {
          Navigator.of(context).pop();
        } else if (serviceResult.shouldSignOutUser) {
          _userService.signOut(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: FloatingActionButton.extended(
        onPressed: () => _handleExerciseAddedInWorkouts(context),
        backgroundColor: Colors.lightGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        label: const Text("Done"),
      ),
    );
  }
}
