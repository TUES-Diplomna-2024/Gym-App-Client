import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_base.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_extended_model.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/utils/components/buttons/profile/profile_actions_popup_menu_button.dart';
import 'package:gym_app_client/utils/components/buttons/profile/profile_admin_actions_popup_menu_button.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';
import 'package:gym_app_client/utils/components/common/custom_app_bar.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/fields/content/date_field.dart';
import 'package:gym_app_client/utils/constants/role_constants.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;
  final void Function()? onUpdate;

  ProfilePage({
    super.key,
    this.userId,
    this.onUpdate,
  }) : assert((userId != null && userId.isNotEmpty && onUpdate != null) ||
            (userId == null && onUpdate == null));

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userService = UserService();
  final _tokenService = TokenService();

  late UserProfileBase _userProfile;
  bool _isLoading = true;
  bool? _isDeleteAllowed;
  bool? _isModifiable;

  @override
  void initState() {
    _loadPage();
    super.initState();
  }

  void _loadPage() {
    if (widget.userId != null && widget.userId!.isNotEmpty) {
      _userService.getUserById(widget.userId!).then(
        (serviceResult) async {
          if (serviceResult.isSuccessful) {
            _userProfile = serviceResult.data! as UserProfileBase;

            if (mounted) {
              setState(() {
                _isLoading = false;
                _isModifiable =
                    (_userProfile as UserProfileExtendedModel).assignableRole !=
                        null;
              });
            }
          } else {
            serviceResult.showPopUp(context);
            if (serviceResult.shouldSignOutUser) _userService.signOut(context);
          }
        },
      );
    } else {
      _userService.getCurrUser().then(
        (serviceResult) async {
          if (serviceResult.isSuccessful) {
            _userProfile = serviceResult.data! as UserProfileBase;

            final currUserRole = await _tokenService.getCurrUserRole();
            _isDeleteAllowed = currUserRole != RoleConstants.superAdminRole;

            if (mounted) setState(() => _isLoading = false);
          } else {
            serviceResult.showPopUp(context);
            if (serviceResult.shouldSignOutUser) _userService.signOut(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.userId == null || widget.userId!.isEmpty)
          ? CustomAppBar(title: "Profile")
          : BackLeadingAppBar(title: "Profile", context: context),
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
                        child: (_userProfile is UserProfileModel)
                            ? ProfileActionsPopupMenuButton(
                                isDeleteAllowed: _isDeleteAllowed!,
                                userStartState:
                                    (_userProfile as UserProfileModel),
                                onUpdate: _loadPage,
                              )
                            : _isModifiable!
                                ? ProfileAdminActionsPopupMenuButton(
                                    userId: _userProfile.id,
                                    assignableRole: (_userProfile
                                            as UserProfileExtendedModel)
                                        .assignableRole!,
                                    onUpdate: ({bool shouldReloadPage = true}) {
                                      widget.onUpdate!();
                                      if (shouldReloadPage) _loadPage();
                                    },
                                  )
                                : const SizedBox.shrink(),
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
                        fieldValue:
                            capitalizeFirstLetter(_userProfile.gender.name),
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
