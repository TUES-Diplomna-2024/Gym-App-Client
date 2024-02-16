import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/utils/components/common/informative_popup.dart';

class ExerciseAddInWorkoutDoneButton extends StatelessWidget {
  final _exerciseService = ExerciseService();
  final String exerciseId;
  final List<String> selectedWorkoutIds;

  ExerciseAddInWorkoutDoneButton({
    super.key,
    required this.exerciseId,
    required this.selectedWorkoutIds,
  });

  Future<void> _handleExerciseAddedInWorkouts(BuildContext context) async {
    if (selectedWorkoutIds.isEmpty) return;

    var result = await _exerciseService.addExerciseInWorkouts(
      exerciseId,
      selectedWorkoutIds,
    );

    if (context.mounted) {
      final popup = InformativePopUp(info: result.popUpInfo!);

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(popup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: FloatingActionButton.extended(
        onPressed: () {
          _handleExerciseAddedInWorkouts(context).then(
            (_) {
              if (context.mounted) Navigator.of(context).pop();
            },
          );
        },
        backgroundColor: Colors.lightGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        label: const Text("Done"),
      ),
    );
  }
}
