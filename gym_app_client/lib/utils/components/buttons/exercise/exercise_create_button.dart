import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_create_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';

class ExerciseCreateButton extends StatelessWidget {
  final ExerciseService _exerciseService = ExerciseService();
  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController muscleGroupController;
  final TextEditingController equipmentController;
  final TextEditingController instructionsController;

  final bool selectedVisibility;
  final String selectedDifficulty;
  final String selectedType;

  ExerciseCreateButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.muscleGroupController,
    required this.equipmentController,
    required this.instructionsController,
    required this.selectedVisibility,
    required this.selectedDifficulty,
    required this.selectedType,
  });

  Future<bool> _handleExerciseCreate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var exercise = ExerciseCreateModel(
        name: nameController.text,
        type: selectedType,
        difficulty: selectedDifficulty,
        muscleGroups: muscleGroupController.text,
        instructions: instructionsController.text,
        equipment:
            equipmentController.text.isEmpty ? null : equipmentController.text,
        isPrivate: selectedVisibility,
      );

      var result = await _exerciseService.createNewExercise(exercise);

      if (context.mounted) {
        debugPrint(result.popUpInfo!.message);
        final popup = InformativePopUp(info: result.popUpInfo!);

        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _handleExerciseCreate(context).then((bool isDone) {
          if (isDone && context.mounted) Navigator.of(context).pop();
        });
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      child: const Text(
        "Create",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
