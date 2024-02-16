import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text(
          "Create Exercise",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
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
