import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/utils/common/enums/gender.dart';
import 'package:gym_app_client/utils/components/buttons/profile/profile_save_changes_button.dart';
import 'package:gym_app_client/utils/components/fields/form/birth_date_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/gender_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/height_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/weight_form_field.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';

class ProfileEditForm extends StatefulWidget {
  final UserProfileModel userInitState;
  final void Function() onUpdate;
  late final EdgeInsets formPadding;
  late final EdgeInsets betweenFieldsPadding;

  ProfileEditForm({
    super.key,
    required this.userInitState,
    required this.onUpdate,
    required EdgeInsets padding,
  }) {
    formPadding = EdgeInsets.only(
      top: padding.top,
      left: padding.left,
      right: padding.right,
    );

    betweenFieldsPadding = EdgeInsets.only(bottom: padding.bottom);
  }

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _birthDateController;

  late Gender _selectedGender;
  late double _selectedHeight;
  late double _selectedWeight;

  @override
  void initState() {
    _usernameController =
        TextEditingController(text: widget.userInitState.username);
    _birthDateController =
        TextEditingController(text: widget.userInitState.birthDate);

    _selectedGender = widget.userInitState.gender;
    _selectedHeight = widget.userInitState.height;
    _selectedWeight = widget.userInitState.weight;

    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.formPadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NameFormField(
              nameController: _usernameController,
              label: "Username",
              hintText: "Enter your username",
              prefixIcon: Icons.person_outline,
              minLength: UserConstants.minUsernameLength,
              maxLength: UserConstants.maxUsernameLength,
              padding: widget.betweenFieldsPadding,
            ),
            BirthDateFormField(
              context: context,
              birthDateController: _birthDateController,
              padding: widget.betweenFieldsPadding,
            ),
            GenderFormField(
              defaultGender: _selectedGender,
              onGenderChanged: (Gender? value) {
                if (mounted) setState(() => _selectedGender = value!);
              },
              padding: widget.betweenFieldsPadding,
            ),
            HeightFormField(
              selectedHeight: _selectedHeight,
              onHeightChanged: (double value) {
                if (mounted) setState(() => _selectedHeight = value);
              },
              padding: widget.betweenFieldsPadding,
            ),
            WeightFormField(
              selectedWeight: _selectedWeight,
              onWeightChanged: (double value) {
                if (mounted) setState(() => _selectedWeight = value);
              },
              padding: widget.betweenFieldsPadding,
            ),
            ProfileSaveChangesButton(
              formKey: _formKey,
              usernameController: _usernameController,
              birthDateController: _birthDateController,
              gender: _selectedGender,
              height: _selectedHeight,
              weight: _selectedWeight,
              onUpdate: widget.onUpdate,
            ),
          ],
        ),
      ),
    );
  }
}
