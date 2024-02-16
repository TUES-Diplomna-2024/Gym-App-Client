import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/common/informative_popup.dart';

class ProfileSaveChangesButton extends StatelessWidget {
  final UserService _userService = UserService();
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController birthDateController;
  final String gender;
  final double height;
  final double weight;
  final void Function(UserUpdateModel) onProfileUpdated;

  ProfileSaveChangesButton({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.birthDateController,
    required this.gender,
    required this.height,
    required this.weight,
    required this.onProfileUpdated,
  });

  Future<(bool, UserUpdateModel?)> _handleProfileUpdate(
      BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var userUpdate = UserUpdateModel(
        username: usernameController.text,
        birthDate: birthDateController.text,
        gender: gender,
        height: height,
        weight: weight,
      );

      var result = await _userService.updateCurrUser(userUpdate);

      if (context.mounted) {
        final popup = InformativePopUp(info: result.popUpInfo!);

        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }

      return (true, userUpdate);
    }

    return (false, null);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleProfileUpdate(context).then((result) {
        bool isDone = result.$1;
        UserUpdateModel? updateModel = result.$2;

        if (isDone && context.mounted) {
          onProfileUpdated(updateModel!);
          Navigator.of(context).pop();
        }
      }),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      child: const Text(
        "Save Changes",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
