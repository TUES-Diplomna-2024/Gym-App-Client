import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/utils/components/buttons/exercise/exercise_save_changes_button.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_difficulty_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_type_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/multiline_text_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';

class ExerciseEditForm extends StatefulWidget {
  final ExerciseViewModel exerciseInitState;
  final void Function(ExerciseUpdateModel) onExerciseUpdated;
  final EdgeInsets formFieldPadding;

  const ExerciseEditForm({
    super.key,
    required this.exerciseInitState,
    required this.onExerciseUpdated,
    required this.formFieldPadding,
  });

  @override
  State<ExerciseEditForm> createState() => _ExerciseEditFormState();
}

class _ExerciseEditFormState extends State<ExerciseEditForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _muscleGroupController;
  late final TextEditingController _equipmentController;
  late final TextEditingController _instructionsController;

  late String _selectedDifficulty;
  late String _selectedType;

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.exerciseInitState.name);
    _muscleGroupController =
        TextEditingController(text: widget.exerciseInitState.muscleGroups);
    _equipmentController =
        TextEditingController(text: widget.exerciseInitState.equipment);
    _instructionsController =
        TextEditingController(text: widget.exerciseInitState.instructions);

    _selectedDifficulty = widget.exerciseInitState.difficulty;
    _selectedType = widget.exerciseInitState.type;

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _muscleGroupController.dispose();
    _equipmentController.dispose();
    _instructionsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NameFormField(
            controller: _nameController,
            label: "Name",
            hintText: "Enter exercise name",
            prefixIcon: Icons.title_outlined,
            minLength: ExerciseConstants.minNameLength,
            maxLength: ExerciseConstants.maxNameLength,
            onChanged: (String value) =>
                setState(() => _nameController.text = value),
            padding: widget.formFieldPadding,
          ),
          ExerciseDifficultyFormField(
            defaultDifficulty: _selectedDifficulty,
            onDifficultyChanged: (String? difficulty) =>
                setState(() => _selectedDifficulty = difficulty!),
            padding: widget.formFieldPadding,
          ),
          ExerciseTypeFormField(
            defaultType: _selectedType,
            onTypeChanged: (String? type) =>
                setState(() => _selectedType = type!),
            padding: widget.formFieldPadding,
          ),
          MultilineTextFormField(
            controller: _muscleGroupController,
            label: "Muscle Groups",
            hintText: "Enter activated muscle groups",
            prefixIcon: Icons.directions_run,
            onChanged: (String? value) =>
                setState(() => _muscleGroupController.text = value!),
            padding: widget.formFieldPadding,
          ),
          MultilineTextFormField(
            controller: _equipmentController,
            label: "Equipment (Optional)",
            hintText: "What exercise equipment is needed?",
            prefixIcon: Icons.fitness_center_outlined,
            isOptional: true,
            onChanged: (String? value) =>
                setState(() => _equipmentController.text = value!),
            padding: widget.formFieldPadding,
          ),
          MultilineTextFormField(
            controller: _instructionsController,
            label: "Instructions",
            hintText: "How to do the exercise?",
            prefixIcon: Icons.sports,
            minLength: ExerciseConstants.minInstructionsLength,
            maxLength: ExerciseConstants.maxInstructionsLength,
            onChanged: (String? value) =>
                setState(() => _instructionsController.text = value!),
            padding: widget.formFieldPadding,
          ),
          ExerciseSaveChangesButton(
            formKey: _formKey,
            exerciseId: widget.exerciseInitState.id,
            nameController: _nameController,
            muscleGroupController: _muscleGroupController,
            equipmentController: _equipmentController,
            instructionsController: _instructionsController,
            selectedDifficulty: _selectedDifficulty,
            selectedType: _selectedType,
            onExerciseUpdated: widget.onExerciseUpdated,
          ),
        ],
      ),
    );
  }
}
