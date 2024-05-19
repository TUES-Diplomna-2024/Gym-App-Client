import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_create_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_view_model.dart';
import 'package:gym_app_client/db_api/services/exercise_record_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/forms/exercise_record_create_update_form.dart';

class ExerciseRecordEditDialog extends StatefulWidget {
  final ExerciseRecordViewModel recordInitState;
  final void Function() updatePage;

  const ExerciseRecordEditDialog({
    super.key,
    required this.recordInitState,
    required this.updatePage,
  });

  @override
  State<ExerciseRecordEditDialog> createState() =>
      _ExerciseRecordEditDialogState();
}

class _ExerciseRecordEditDialogState extends State<ExerciseRecordEditDialog> {
  final _userService = UserService();
  final _exerciseRecordService = ExerciseRecordService();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _weightController;

  late Duration _duration;

  @override
  void initState() {
    _setsController =
        TextEditingController(text: widget.recordInitState.sets.toString());
    _repsController =
        TextEditingController(text: widget.recordInitState.reps.toString());

    _weightController = TextEditingController(
      text: widget.recordInitState.weight != 0
          ? widget.recordInitState.weight.toString()
          : "",
    );

    _duration = widget.recordInitState.duration;

    super.initState();
  }

  void _handleRecordUpdate() {
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
          .updateExerciseRecordById(widget.recordInitState.id, record)
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
        child: Text("Edit Record"),
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
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _handleRecordUpdate,
          child: const Text(
            "Save Changes",
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
