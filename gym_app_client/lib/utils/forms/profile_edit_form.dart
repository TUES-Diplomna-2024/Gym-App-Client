import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/utils/components/buttons/profile/profile_save_changes_button.dart';
import 'package:gym_app_client/utils/components/fields/form/birth_date_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/gender_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/height_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/weight_form_field.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';

class ProfileEditForm extends Form {
  ProfileEditForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController usernameController,
    required TextEditingController birthDateController,
    required String selectedGender,
    required double selectedHeight,
    required double selectedWeight,
    required void Function(String) onUsernameChanged,
    required void Function(String) onBirthDateChanged,
    required void Function(String?) onGenderChanged,
    required void Function(double) onHeightChanged,
    required void Function(double) onWeightChanged,
    required void Function(UserUpdateModel) onProfileUpdated,
    required EdgeInsets formFieldPadding,
  }) : super(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NameFormField(
                controller: usernameController,
                label: "Username",
                hintText: "Enter your username",
                prefixIcon: Icons.person_outline,
                minLength: UserConstants.minUsernameLength,
                maxLength: UserConstants.maxUsernameLength,
                onChanged: onUsernameChanged,
                padding: formFieldPadding,
              ),
              BirthDateFormField(
                context: context,
                birthDateController: birthDateController,
                onBirthDateChanged: onBirthDateChanged,
                padding: formFieldPadding,
              ),
              GenderFormField(
                defaultGender: selectedGender,
                onGenderChanged: onGenderChanged,
                padding: formFieldPadding,
              ),
              HeightFormField(
                selectedHeight: selectedHeight,
                onHeightChanged: onHeightChanged,
                padding: formFieldPadding,
              ),
              WeightFormField(
                selectedWeight: selectedWeight,
                onWeightChanged: onWeightChanged,
                padding: formFieldPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Exit",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: ProfileSaveChangesButton(
                      formKey: formKey,
                      usernameController: usernameController,
                      birthDateController: birthDateController,
                      gender: selectedGender,
                      height: selectedHeight,
                      weight: selectedWeight,
                      onProfileUpdated: onProfileUpdated,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
}
