import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_create_update_model.dart';
import 'package:gym_app_client/db_api/services/exercise_record_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/forms/exercise_record_create_update_form.dart';

class ExerciseRecordCreateDialog extends StatefulWidget {
  final String exerciseId;
  final void Function() updatePage;

  const ExerciseRecordCreateDialog({
    super.key,
    required this.exerciseId,
    required this.updatePage,
  });

  @override
  State<ExerciseRecordCreateDialog> createState() =>
      _ExerciseRecordCreateDialogState();
}

class _ExerciseRecordCreateDialogState
    extends State<ExerciseRecordCreateDialog> {
  final _userService = UserService();
  final _exerciseRecordService = ExerciseRecordService();

  final _formKey = GlobalKey<FormState>();

  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  Duration _duration = const Duration();

  void _handleRecordCreation() {
    if (_formKey.currentState?.validate() ?? false) {
      var record = ExerciseRecordCreateUpdateModel(
        sets: int.parse(_setsController.text),
        reps: int.parse(_repsController.text),
        weight: _weightController.text.isEmpty
            ? null
            : double.parse(_weightController.text),
        duration: _duration.inSeconds,
      );

      _exerciseRecordService
          .createNewExerciseRecord(widget.exerciseId, record)
          .then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.isSuccessful && context.mounted) {
            Navigator.of(context).pop();
            widget.updatePage();
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
        child: Text("Create Record"),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ExerciseRecordCreateUpdateForm(
              formKey: _formKey,
              setsController: _setsController,
              repsController: _repsController,
              weightController: _weightController,
              initDuration: _duration,
              onDurationChanged: (Duration value) {
                if (mounted) setState(() => _duration = value);
              },
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _handleRecordCreation,
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
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
