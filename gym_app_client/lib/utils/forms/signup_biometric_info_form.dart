import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/gender.dart';
import 'package:gym_app_client/utils/components/fields/form/birth_date_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/gender_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/height_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/weight_form_field.dart';

class SignUpBiometricInfoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController birthDateController;
  final double selectedHeight;
  final double selectedWeight;
  final void Function(Gender?) onGenderChanged;
  final void Function(double) onHeightChanged;
  final void Function(double) onWeightChanged;
  final EdgeInsets formPadding;
  final EdgeInsets betweenFieldsPadding;

  const SignUpBiometricInfoForm({
    super.key,
    required this.formKey,
    required this.birthDateController,
    required this.selectedHeight,
    required this.selectedWeight,
    required this.onGenderChanged,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.formPadding,
    required this.betweenFieldsPadding,
  });

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
            BirthDateFormField(
              context: context,
              birthDateController: birthDateController,
              padding: betweenFieldsPadding,
            ),
            GenderFormField(
              onGenderChanged: onGenderChanged,
              padding: betweenFieldsPadding,
            ),
            HeightFormField(
              selectedHeight: selectedHeight,
              onHeightChanged: onHeightChanged,
              padding: betweenFieldsPadding,
            ),
            WeightFormField(
              selectedWeight: selectedWeight,
              onWeightChanged: onWeightChanged,
              padding: betweenFieldsPadding,
            ),
          ],
        ),
      ),
    );
  }
}
