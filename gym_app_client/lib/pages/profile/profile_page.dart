import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/buttons/profile/profile_delete_button.dart';
import 'package:gym_app_client/utils/components/buttons/profile/profile_edit_button.dart';
import 'package:gym_app_client/utils/components/common/custom_app_bar.dart';
import 'package:gym_app_client/utils/components/common/informative_popup.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/fields/content/date_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userService = UserService();
  late UserProfileModel _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    _getUserProfile();
    super.initState();
  }

  Future<void> _getUserProfile() async {
    final serviceResult = await _userService.getCurrUser();

    if (serviceResult.popUpInfo != null) {
      final popup = InformativePopUp(info: serviceResult.popUpInfo!);

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }
    } else {
      _userProfile = serviceResult.data!;
      if (mounted) setState(() => _isLoading = false);
    }
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
                      const SizedBox(height: 23),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ProfileEditButton(
                              context: context,
                              userStartState: _userProfile,
                              onProfileUpdated: (updateModel) {
                                if (mounted) {
                                  setState(() =>
                                      _userProfile.updateProfile(updateModel));
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            child: ProfileDeleteButton(context: context),
                          ),
                        ],
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
                        fieldValue: "${_userProfile.height} cm",
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      ContentField(
                        fieldIcon: Icons.scale_outlined,
                        fieldName: "Weight",
                        fieldValue: "${_userProfile.height} kg",
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
