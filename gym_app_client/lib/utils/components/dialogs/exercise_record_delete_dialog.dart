import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/exercise_record_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/dialogs/delete_item_dialog.dart';

class ExerciseRecordDeleteDialog extends DeleteItemDialog {
  final _userService = UserService();
  final _exerciseRecordService = ExerciseRecordService();

  final String exerciseId;
  final String recordId;
  final void Function() updatePage;

  ExerciseRecordDeleteDialog({
    super.key,
    required super.context,
    required this.exerciseId,
    required this.recordId,
    required this.updatePage,
  }) : super(itemType: "record");

  @override
  void handleItemDeletion() {
    _exerciseRecordService.deleteExerciseRecordById(exerciseId, recordId).then(
      (serviceResult) {
        serviceResult.showPopUp(context);

        if (serviceResult.isSuccessful && context.mounted) {
          Navigator.of(context).pop();
          updatePage();
        } else if (serviceResult.shouldSignOutUser) {
          _userService.signOut(context);
        }
      },
    );
  }
}
