import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/form_page.dart';
import 'package:gym_app_client/utils/forms/exercise_create_form.dart';

class ExerciseCreatePage extends FormPage {
  ExerciseCreatePage({
    super.key,
    required void Function() onUpdate,
  }) : super(
          title: "Create Exercise",
          form: ExerciseCreateForm(
            onUpdate: onUpdate,
            padding:
                const EdgeInsets.only(top: 35, bottom: 35, left: 25, right: 25),
          ),
        );
}
