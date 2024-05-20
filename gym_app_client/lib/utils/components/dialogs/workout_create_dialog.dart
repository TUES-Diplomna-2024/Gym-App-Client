import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_create_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';
import 'package:gym_app_client/utils/forms/workout_create_form.dart';

class WorkoutCreateDialog extends StatefulWidget {
  final void Function() onUpdate;

  const WorkoutCreateDialog({
    super.key,
    required this.onUpdate,
  });

  @override
  State<WorkoutCreateDialog> createState() => _WorkoutCreateDialogState();
}

class _WorkoutCreateDialogState extends State<WorkoutCreateDialog> {
  final _userService = UserService();
  final _workoutService = WorkoutService();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _handleWorkoutCreation() {
    if (_formKey.currentState?.validate() ?? false) {
      var workout = WorkoutCreateModel(
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      _workoutService.createNewWorkout(workout).then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.isSuccessful && context.mounted) {
            widget.onUpdate();
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
    return AlertDialog(
      title: const Center(
        child: Text("Create Workout"),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            WorkoutCreateForm(
              formKey: _formKey,
              nameController: _nameController,
              descriptionController: _descriptionController,
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _handleWorkoutCreation,
          child: const Text(
            "Create",
            style: TextStyle(color: Colors.lightGreen),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
