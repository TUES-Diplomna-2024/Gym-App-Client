import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/utils/components/buttons/exercise/exercise_create_button.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_difficulty_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_type_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/multiline_text_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_visibility_form_field.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';
import 'package:gym_app_client/utils/constants/role_constants.dart';

class ExerciseCreateForm extends StatefulWidget {
  final EdgeInsets formFieldPadding;

  const ExerciseCreateForm({
    super.key,
    required this.formFieldPadding,
  });

  @override
  State<ExerciseCreateForm> createState() => _ExerciseCreateFormState();
}

class _ExerciseCreateFormState extends State<ExerciseCreateForm> {
  final _tokenService = TokenService();
  bool _isCurrUserAdmin = false;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _muscleGroupController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _instructionsController = TextEditingController();

  bool _selectedVisibility = ExerciseConstants.privateVisibility;
  String _selectedDifficulty = "";
  String _selectedType = "";

  @override
  void initState() {
    super.initState();
    _setCurrentUserAdmin();
  }

  Future<void> _setCurrentUserAdmin() async {
    final currUserRole = await _tokenService.getCurrUserRole();

    setState(() {
      _isCurrUserAdmin = RoleConstants.adminRoles.contains(currUserRole);
    });
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
          if (_isCurrUserAdmin)
            ExerciseVisibilityFormField(
              defaultVisibility: _selectedVisibility,
              onVisibilityChanged: (bool? visibility) =>
                  setState(() => _selectedVisibility = visibility!),
              padding: widget.formFieldPadding,
            ),
          ExerciseDifficultyFormField(
            onDifficultyChanged: (String? difficulty) =>
                setState(() => _selectedDifficulty = difficulty!),
            padding: widget.formFieldPadding,
          ),
          ExerciseTypeFormField(
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
                setState(() => _muscleGroupController.text = value!),
            padding: widget.formFieldPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Exit",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: ExerciseCreateButton(
                  formKey: _formKey,
                  nameController: _nameController,
                  muscleGroupController: _muscleGroupController,
                  equipmentController: _equipmentController,
                  instructionsController: _instructionsController,
                  selectedVisibility: _selectedVisibility,
                  selectedDifficulty: _selectedDifficulty,
                  selectedType: _selectedType,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _muscleGroupController.dispose();
    _equipmentController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}
