import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';
import 'package:gym_app_client/utils/components/dialogs/delete_item_dialog.dart';

class WorkoutDeleteDialog extends DeleteItemDialog {
  final _userService = UserService();
  final _workoutService = WorkoutService();

  final String workoutId;

  WorkoutDeleteDialog({
    super.key,
    required super.context,
    required this.workoutId,
  }) : super(itemType: "workout");

  @override
  void handleItemDeletion() {
    _workoutService.deleteWorkoutById(workoutId).then(
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
}
