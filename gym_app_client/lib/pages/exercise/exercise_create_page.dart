import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';
import 'package:gym_app_client/utils/forms/exercise_create_form.dart';

class ExerciseCreatePage extends StatefulWidget {
  const ExerciseCreatePage({super.key});

  @override
  State<ExerciseCreatePage> createState() => _ExerciseCreatePageState();
}

class _ExerciseCreatePageState extends State<ExerciseCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackLeadingAppBar(title: "Create Exercise", context: context),
      body: const Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 35, bottom: 35, left: 25, right: 25),
            child: ExerciseCreateForm(
              formFieldPadding: EdgeInsets.only(bottom: 25),
            ),
          ),
        ),
      ),
    );
  }
}
