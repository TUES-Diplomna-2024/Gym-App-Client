import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/multiline_text_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/constants/workout_constants.dart';

class WorkoutCreateForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  late final EdgeInsets formPadding;
  late final EdgeInsets betweenFieldsPadding;

  WorkoutCreateForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
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
            NameFormField(
              nameController: nameController,
              label: "Name",
              hintText: "Enter workout name",
              prefixIcon: Icons.title_outlined,
              minLength: WorkoutConstants.minNameLength,
              maxLength: WorkoutConstants.maxNameLength,
              padding: betweenFieldsPadding,
            ),
            MultilineTextFormField(
              controller: descriptionController,
              label: "Description",
              hintText: "Enter workout description",
              prefixIcon: Icons.description_outlined,
              maxLength: WorkoutConstants.maxDescriptionLength,
              isOptional: true,
              padding: const EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }
}
