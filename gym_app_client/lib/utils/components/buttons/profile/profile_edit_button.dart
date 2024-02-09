import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';

class ProfileEditButton extends ElevatedButton {
  ProfileEditButton({
    super.key,
    required BuildContext context,
    required UserProfileModel userStartState,
    required void Function(UserUpdateModel) onProfileUpdated,
  }) : super(
          onPressed: () => Navigator.of(context).pushNamed("/profile-edit",
              arguments: [userStartState, onProfileUpdated]),
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade400),
          child: const Text("Edit"),
        );
}
