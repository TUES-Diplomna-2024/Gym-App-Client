import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/common/enums/gender.dart';

class ProfileSaveChangesButton extends StatelessWidget {
  final UserService _userService = UserService();
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController birthDateController;
  final Gender gender;
  final double height;
  final double weight;
  final void Function() onUpdate;

  ProfileSaveChangesButton({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.birthDateController,
    required this.gender,
    required this.height,
    required this.weight,
    required this.onUpdate,
  });

  void _handleProfileUpdate(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      var userUpdate = UserUpdateModel(
        username: usernameController.text,
        birthDate: birthDateController.text,
        gender: gender,
        height: height,
        weight: weight,
      );

      _userService.updateCurrUser(userUpdate).then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.isSuccessful) {
            onUpdate();
            if (context.mounted) Navigator.of(context).pop();
          } else if (serviceResult.shouldSignOutUser) {
            _userService.signOut(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleProfileUpdate(context),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      child: const Text(
        "Save Changes",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
