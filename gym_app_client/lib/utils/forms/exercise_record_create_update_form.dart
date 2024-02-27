import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/training_duration_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/unsigned_double_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/unsigned_int_form_field.dart';
import 'package:gym_app_client/utils/constants/exercise_record_constants.dart';

class ExerciseRecordCreateUpdateForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final Duration initDuration;
  final void Function(Duration) onDurationChanged;
  late final EdgeInsets formPadding;
  late final EdgeInsets betweenFieldsPadding;

  ExerciseRecordCreateUpdateForm({
    super.key,
    required this.formKey,
    required this.setsController,
    required this.repsController,
    required this.weightController,
    required this.initDuration,
    required this.onDurationChanged,
    required EdgeInsets padding,
  }) {
    formPadding = EdgeInsets.only(
      left: padding.left,
      right: padding.right,
    );

    betweenFieldsPadding = EdgeInsets.only(bottom: padding.bottom);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: formPadding,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UnsignedIntFormField(
              numberController: setsController,
              label: "Sets",
              hintText: "Enter your sets",
              prefixIcon: Icons.view_list,
              minValue: ExerciseRecordConstants.minSetsValue,
              padding: betweenFieldsPadding,
            ),
            UnsignedIntFormField(
              numberController: repsController,
              label: "Reps",
              hintText: "Enter your reps",
              prefixIcon: Icons.repeat,
              minValue: ExerciseRecordConstants.minRepsValue,
              padding: betweenFieldsPadding,
            ),
            UnsignedDoubleFormField(
              numberController: weightController,
              label: "Weight",
              hintText: "Enter used weight",
              prefixIcon: Icons.scale_outlined,
              isOptional: true,
              minValue: ExerciseRecordConstants.minWeightValue,
              maxValue: ExerciseRecordConstants.maxWeightValue,
              padding: betweenFieldsPadding,
            ),
            TrainingDurationFormField(
              initDuration: initDuration,
              minDuration: ExerciseRecordConstants.minDuration,
              onDurationChanged: onDurationChanged,
              padding: const EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }
}
