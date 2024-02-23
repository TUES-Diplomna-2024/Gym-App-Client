import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_create_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';

class ExerciseCreateButton extends StatelessWidget {
  final _userService = UserService();
  final _exerciseService = ExerciseService();

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

  void _handleExerciseCreate(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
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

      _exerciseService.createNewExercise(exercise).then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.isSuccessful && context.mounted) {
            Navigator.of(context).pop();
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
      onPressed: () => _handleExerciseCreate(context),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      child: const Text(
        "Create",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
