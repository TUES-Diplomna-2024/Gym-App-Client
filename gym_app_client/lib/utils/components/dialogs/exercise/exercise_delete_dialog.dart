import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/utils/components/common/informative_popup.dart';

class ExerciseDeleteDialog extends StatelessWidget {
  final _exerciseService = ExerciseService();
  final BuildContext context;
  final String exerciseId;

  ExerciseDeleteDialog({
    super.key,
    required this.context,
    required this.exerciseId,
  });

  Future<void> _handleExerciseDeletion() async {
    var result = await _exerciseService.deleteExerciseById(exerciseId);

    if (context.mounted) {
      final popup = InformativePopUp(info: result.popUpInfo!);

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(popup);
    }
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
          onPressed: () => _handleExerciseDeletion().then((_) {
            if (context.mounted) Navigator.of(context).pop();
          }),
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red.shade400),
          ),
        ),
      ],
    );
  }
}
