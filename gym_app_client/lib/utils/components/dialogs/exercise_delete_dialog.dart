import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/dialogs/delete_item_dialog.dart';

class ExerciseDeleteDialog extends DeleteItemDialog {
  final _userService = UserService();
  final _exerciseService = ExerciseService();

  final String exerciseId;
  final void Function() onUpdate;

  ExerciseDeleteDialog({
    super.key,
    required super.context,
    required this.exerciseId,
    required this.onUpdate,
  }) : super(itemType: "exercise");

  @override
  void handleItemDeletion() {
    _exerciseService.deleteExerciseById(exerciseId).then(
      (serviceResult) {
        serviceResult.showPopUp(context);

        if (serviceResult.isSuccessful && context.mounted) {
          onUpdate();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else if (serviceResult.shouldSignOutUser) {
          _userService.signOut(context);
        }
      },
    );
  }
}
