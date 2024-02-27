import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/utils/components/buttons/profile/profile_actions_popup_menu_button.dart';
import 'package:gym_app_client/utils/components/common/custom_app_bar.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/fields/content/date_field.dart';
import 'package:gym_app_client/utils/constants/role_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userService = UserService();
  final _tokenService = TokenService();

  late UserProfileModel _userProfile;
  late final bool _isDeleteAllowed;
  bool _isLoading = true;

  @override
  void initState() {
    _userService.getCurrUser().then(
      (serviceResult) async {
        if (serviceResult.isSuccessful) {
          _userProfile = serviceResult.data!;

          final currUserRole = await _tokenService.getCurrUserRole();
          _isDeleteAllowed = currUserRole != RoleConstants.superAdminRole;

          if (mounted) setState(() => _isLoading = false);
        } else {
          serviceResult.showPopUp(context);
          if (serviceResult.shouldSignOutUser) _userService.signOut(context);
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: ProfileActionsPopupMenuButton(
                          isDeleteAllowed: _isDeleteAllowed,
                          userStartState: _userProfile,
                          onProfileUpdated: (updateModel) {
                            if (mounted) {
                              setState(() =>
                                  _userProfile.updateProfile(updateModel));
                            }
                          },
                        ),
                      ),
                      Text(
                        _userProfile.username,
                        style: const TextStyle(fontSize: 26),
                      ),
                      Text(
                        _userProfile.roleName,
                        style: TextStyle(
                          fontSize: 16,
                          color: _userProfile.roleColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      DateField(
                        dateIcon: Icons.calendar_month_outlined,
                        dateName: "Member Since",
                        dateValue: _userProfile.onCreated,
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      ContentField(
                        fieldIcon: Icons.mail_outline,
                        fieldName: "Email",
                        fieldValue: _userProfile.email,
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      ContentField(
                        fieldIcon: Icons.accessibility_new_outlined,
                        fieldName: "Gender",
                        fieldValue: _userProfile.gender,
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      DateField(
                        dateIcon: Icons.cake_outlined,
                        dateName: "Birth Date",
                        dateValue: _userProfile.birthDate,
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      ContentField(
                        fieldIcon: Icons.height_outlined,
                        fieldName: "Height",
                        fieldValue: getHeightString(_userProfile.height),
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      ContentField(
                        fieldIcon: Icons.scale_outlined,
                        fieldName: "Weight",
                        fieldValue: getWeightString(_userProfile.weight),
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
