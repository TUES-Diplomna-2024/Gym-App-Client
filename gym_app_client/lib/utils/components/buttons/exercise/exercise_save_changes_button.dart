import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';

class ExerciseSaveChangesButton extends StatelessWidget {
  final _userService = UserService();
  final _exerciseService = ExerciseService();

  final GlobalKey<FormState> formKey;

  final String exerciseId;

  final TextEditingController nameController;
  final TextEditingController muscleGroupController;
  final TextEditingController equipmentController;
  final TextEditingController instructionsController;

  final ExerciseDifficulty selectedDifficulty;
  final ExerciseType selectedType;

  final void Function() onUpdate;

  ExerciseSaveChangesButton({
    super.key,
    required this.formKey,
    required this.exerciseId,
    required this.nameController,
    required this.muscleGroupController,
    required this.equipmentController,
    required this.instructionsController,
    required this.selectedDifficulty,
    required this.selectedType,
    required this.onUpdate,
  });

  void _handleExerciseUpdate(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      var exerciseUpdate = ExerciseUpdateModel(
        name: nameController.text,
        instructions: instructionsController.text,
        muscleGroups: muscleGroupController.text,
        type: selectedType,
        difficulty: selectedDifficulty,
        equipment:
            equipmentController.text.isEmpty ? null : equipmentController.text,
      );

      _exerciseService.updateExerciseById(exerciseId, exerciseUpdate).then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.isSuccessful) {
            onUpdate();
            if (context.mounted) Navigator.of(context).pop();
          } else if (serviceResult.shouldSignOutUser) {
            _userService.signOut(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleExerciseUpdate(context),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      child: const Text(
        "Save Changes",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
