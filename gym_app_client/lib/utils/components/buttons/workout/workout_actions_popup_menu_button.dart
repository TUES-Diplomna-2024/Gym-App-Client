import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:gym_app_client/utils/components/dialogs/exercise_delete_dialog.dart';
import 'package:gym_app_client/utils/components/dialogs/workout_delete_dialog.dart';

class WorkoutActionsPopupMenuButton extends PopupMenuButton {
  WorkoutActionsPopupMenuButton({
    super.key,
    required WorkoutViewModel workoutCurrState,
    required void Function(String, String?, List<ExercisePreviewModel>?)
        onWorkoutUpdated,
  }) : super(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                      "/workout-edit",
                      arguments: [workoutCurrState, onWorkoutUpdated],
                    );
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 16),
                    Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => WorkoutDeleteDialog(
                        context: context,
                        workoutId: workoutCurrState.id,
                      ),
                    );
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 16),
                    Text("Delete"),
                  ],
                ),
              ),
            ];
          },
        );
}
