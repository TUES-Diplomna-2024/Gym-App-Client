import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/forms/form_fields/birth_date_form_field.dart';
import 'package:gym_app_client/utils/forms/form_fields/gender_form_field.dart';
import 'package:gym_app_client/utils/forms/form_fields/height_form_field.dart';
import 'package:gym_app_client/utils/forms/form_fields/weight_form_field.dart';

class SignUpBiometricInfoForm extends Form {
  SignUpBiometricInfoForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController birthDateController,
    required double selectedHeight,
    required double selectedWeight,
    required void Function(String) onBirthDateChanged,
    required void Function(String?) onGenderChanged,
    required void Function(double) onHeightChanged,
    required void Function(double) onWeightChanged,
    required EdgeInsets formFieldPadding,
  }) : super(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BirthDateFormField(
                  context: context,
                  birthDateController: birthDateController,
                  onBirthDateChanged: onBirthDateChanged,
                  padding: formFieldPadding,
                ),
                GenderFormField(
                  onGenderChanged: onGenderChanged,
                  padding: formFieldPadding,
                ),
                HeightFormField(
                  selectedHeight: selectedHeight,
                  onHeightChanged: onHeightChanged,
                  padding: EdgeInsets.only(
                    top: formFieldPadding.top,
                    bottom: formFieldPadding.bottom,
                  ),
                ),
                WeightFormField(
                  selectedWeight: selectedWeight,
                  onWeightChanged: onWeightChanged,
                  padding: EdgeInsets.only(
                    top: formFieldPadding.top,
                    bottom: formFieldPadding.bottom,
                  ),
                ),
              ],
            ),
          ),
        );
}
