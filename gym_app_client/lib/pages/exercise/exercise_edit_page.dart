import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';
import 'package:gym_app_client/utils/forms/exercise_edit_form.dart';

class ExerciseEditPage extends StatefulWidget {
  final ExerciseViewModel exerciseInitState;
  final void Function(ExerciseUpdateModel) onExerciseUpdated;

  const ExerciseEditPage({
    super.key,
    required this.exerciseInitState,
    required this.onExerciseUpdated,
  });

  @override
  State<ExerciseEditPage> createState() => _ExerciseEditPageState();
}

class _ExerciseEditPageState extends State<ExerciseEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackLeadingAppBar(title: "Edit Exercise", context: context),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 35, left: 25, right: 25),
            child: ExerciseEditForm(
              exerciseInitState: widget.exerciseInitState,
              onExerciseUpdated: widget.onExerciseUpdated,
              formFieldPadding: const EdgeInsets.only(bottom: 25),
            ),
          ),
        ),
      ),
    );
  }
}
