import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';
import 'package:gym_app_client/utils/forms/profile_edit_form.dart';

class ProfileEditPage extends StatefulWidget {
  final UserProfileModel userInitState;
  final void Function(UserUpdateModel) onProfileUpdated;

  const ProfileEditPage({
    super.key,
    required this.userInitState,
    required this.onProfileUpdated,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _birthDateController;

  late String _selectedGender;
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
    return Scaffold(
      appBar: BackLeadingAppBar(title: "Edit Profile", context: context),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 35, left: 25, right: 25),
            child: ProfileEditForm(
              context: context,
              formKey: _formKey,
              usernameController: _usernameController,
              birthDateController: _birthDateController,
              selectedGender: _selectedGender,
              selectedHeight: _selectedHeight,
              selectedWeight: _selectedWeight,
              onUsernameChanged: (String value) {
                if (mounted) setState(() => _usernameController.text = value);
              },
              onBirthDateChanged: (String value) {
                if (mounted) setState(() => _birthDateController.text = value);
              },
              onGenderChanged: (String? value) {
                if (mounted) setState(() => _selectedGender = value!);
              },
              onHeightChanged: (double value) {
                if (mounted) setState(() => _selectedHeight = value);
              },
              onWeightChanged: (double value) {
                if (mounted) setState(() => _selectedWeight = value);
              },
              onProfileUpdated: widget.onProfileUpdated,
              formFieldPadding: const EdgeInsets.only(bottom: 25),
            ),
          ),
        ),
      ),
    );
  }
}
