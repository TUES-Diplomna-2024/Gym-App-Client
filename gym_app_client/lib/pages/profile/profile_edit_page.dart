import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/pages/form_page.dart';
import 'package:gym_app_client/utils/forms/profile_edit_form.dart';

class ProfileEditPage extends FormPage {
  ProfileEditPage({
    super.key,
    required UserProfileModel userInitState,
    required void Function(UserUpdateModel) onProfileUpdated,
  }) : super(
          title: "Edit Profile",
          form: ProfileEditForm(
            userInitState: userInitState,
            onProfileUpdated: onProfileUpdated,
            padding:
                const EdgeInsets.only(top: 35, left: 25, right: 25, bottom: 25),
          ),
        );
}
