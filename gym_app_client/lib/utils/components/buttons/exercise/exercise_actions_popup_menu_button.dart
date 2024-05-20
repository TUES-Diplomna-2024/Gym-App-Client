import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';
import 'package:gym_app_client/utils/components/dialogs/exercise_delete_dialog.dart';

class ExerciseActionsPopupMenuButton extends PopupMenuButton {
  ExerciseActionsPopupMenuButton({
    super.key,
    required bool isModifiable,
    required ExerciseViewModel exerciseCurrState,
    required void Function({bool shouldReloadPage}) onUpdate,
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
              if (isModifiable) ...{
                PopupMenuItem(
                  onTap: () {
                    if (context.mounted) {
                      Navigator.of(context).pushNamed(
                        "/exercise-edit",
                        arguments: [exerciseCurrState, onUpdate],
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
                if (!exerciseCurrState.isCustom) ...{
                  PopupMenuItem(
                    onTap: () {
                      if (context.mounted) {
                        var newVisibility = exerciseCurrState.visibility ==
                                ExerciseVisibility.public
                            ? ExerciseVisibility.private
                            : ExerciseVisibility.public;

                        ExerciseService()
                            .updateExerciseVisibilityById(
                                exerciseCurrState.id, newVisibility)
                            .then(
                          (serviceResult) {
                            serviceResult.showPopUp(context);

                            if (serviceResult.isSuccessful && context.mounted) {
                              onUpdate();
                            } else if (serviceResult.shouldSignOutUser) {
                              UserService().signOut(context);
                            }
                          },
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          exerciseCurrState.visibility ==
                                  ExerciseVisibility.private
                              ? Icons.public_outlined
                              : Icons.lock_outlined,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          exerciseCurrState.visibility ==
                                  ExerciseVisibility.private
                              ? "Make Public"
                              : "Make Private",
                        ),
                      ],
                    ),
                  )
                },
                PopupMenuItem(
                  onTap: () {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => ExerciseDeleteDialog(
                          context: context,
                          exerciseId: exerciseCurrState.id,
                          onUpdate: () => onUpdate(shouldReloadPage: false),
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
