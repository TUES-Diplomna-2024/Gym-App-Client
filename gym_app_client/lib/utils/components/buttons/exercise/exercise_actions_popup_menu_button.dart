import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/utils/components/dialogs/exercise_delete_dialog.dart';

class ExerciseActionsPopupMenuButton extends PopupMenuButton {
  ExerciseActionsPopupMenuButton({
    super.key,
    required bool areEditAndDeleteAllowed,
    required ExerciseViewModel exerciseCurrState,
    required void Function(ExerciseUpdateModel) onExerciseUpdated,
  }) : super(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                      "/exercise-add-in-workouts",
                      arguments: exerciseCurrState.id,
                    );
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.add_circle_outline),
                    SizedBox(width: 16),
                    Text("Add In Workouts"),
                  ],
                ),
              ),
              if (areEditAndDeleteAllowed) ...{
                PopupMenuItem(
                  onTap: () {
                    if (context.mounted) {
                      Navigator.of(context).pushNamed(
                        "/exercise-edit",
                        arguments: [exerciseCurrState, onExerciseUpdated],
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
                        builder: (_) => ExerciseDeleteDialog(
                          context: context,
                          exerciseId: exerciseCurrState.id,
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
              },
            ];
          },
        );
}
