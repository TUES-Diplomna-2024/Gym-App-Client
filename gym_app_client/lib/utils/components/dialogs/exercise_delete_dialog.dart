import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';

class ExerciseDeleteDialog extends StatelessWidget {
  final _userService = UserService();
  final _exerciseService = ExerciseService();
  final BuildContext context;
  final String exerciseId;

  ExerciseDeleteDialog({
    super.key,
    required this.context,
    required this.exerciseId,
  });

  void _handleExerciseDeletion() {
    _exerciseService.deleteExerciseById(exerciseId).then(
      (serviceResult) {
        serviceResult.showPopUp(context);

        if (serviceResult.isSuccessful && context.mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else if (serviceResult.shouldSignOutUser) {
          _userService.signOut(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text("Delete Exercise"),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Text(
          "Are you absolutely sure you want to delete this exercise? This action is permanent and cannot be undone!",
          style: TextStyle(color: Colors.red.shade500),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _handleExerciseDeletion,
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red.shade400),
          ),
        ),
      ],
    );
  }
}
