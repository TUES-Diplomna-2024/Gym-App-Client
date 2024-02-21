import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/dialogs/profile_delete_dialog.dart';

class ProfileActionsPopupMenuButton extends PopupMenuButton {
  ProfileActionsPopupMenuButton({
    super.key,
    required UserProfileModel userStartState,
    required void Function(UserUpdateModel) onProfileUpdated,
  }) : super(
          icon: const Icon(Icons.settings),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                      "/profile-edit",
                      arguments: [userStartState, onProfileUpdated],
                    );
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 16),
                    Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => UserService().signOut(context),
                child: const Row(
                  children: [
                    Icon(Icons.logout_outlined),
                    SizedBox(width: 16),
                    Text("Sign Out"),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => const ProfileDeleteDialog(),
                    );
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 16),
                    Text("Delete"),
                  ],
                ),
              ),
            ];
          },
        );
}
