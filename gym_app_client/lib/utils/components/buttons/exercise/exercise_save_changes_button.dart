import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';

class ExerciseSaveChangesButton extends StatelessWidget {
  final ExerciseService _exerciseService = ExerciseService();
  final GlobalKey<FormState> formKey;

  final String exerciseId;

  final TextEditingController nameController;
  final TextEditingController muscleGroupController;
  final TextEditingController equipmentController;
  final TextEditingController instructionsController;

  final String selectedDifficulty;
  final String selectedType;

  final void Function(ExerciseUpdateModel) onExerciseUpdated;

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
    required this.onExerciseUpdated,
  });

  Future<(bool, ExerciseUpdateModel?)> _handleExerciseUpdate(
      BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var exerciseUpdate = ExerciseUpdateModel(
        name: nameController.text,
        instructions: instructionsController.text,
        muscleGroups: muscleGroupController.text,
        type: selectedType,
        difficulty: selectedDifficulty,
        equipment:
            equipmentController.text.isEmpty ? null : equipmentController.text,
      );

      var result =
          await _exerciseService.updateExerciseById(exerciseId, exerciseUpdate);

      if (context.mounted) {
        final popup = InformativePopUp(info: result.popUpInfo!);

        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }

      return (true, exerciseUpdate);
    }

    return (false, null);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleExerciseUpdate(context).then((result) {
        bool isDone = result.$1;
        ExerciseUpdateModel? updateModel = result.$2;

        if (isDone && context.mounted) {
          onExerciseUpdated(updateModel!);
          Navigator.of(context).pop();
        }
      }),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      child: const Text(
        "Save Changes",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
