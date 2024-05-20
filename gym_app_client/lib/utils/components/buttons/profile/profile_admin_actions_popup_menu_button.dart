import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/common/enums/assignable_role.dart';
import 'package:gym_app_client/utils/components/dialogs/profile_delete_dialog.dart';

class ProfileAdminActionsPopupMenuButton extends PopupMenuButton {
  ProfileAdminActionsPopupMenuButton({
    super.key,
    required String userId,
    required AssignableRole assignableRole,
    required void Function({bool shouldReloadPage}) onUpdate,
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
                    UserService().assignUserRole(userId, assignableRole).then(
                      (serviceResult) {
                        serviceResult.showPopUp(context);

                        if (serviceResult.isSuccessful && context.mounted) {
                          onUpdate();
                        } else if (serviceResult.shouldSignOutUser) {
                          UserService().signOut(context);
                        }
                      },
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      assignableRole == AssignableRole.admin
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      assignableRole == AssignableRole.admin
                          ? "Promote to Admin"
                          : "Demote to Normie",
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => ProfileDeleteDialog(
                        isPasswordRequired: false,
                        userId: userId,
                        onUpdate: () => onUpdate(shouldReloadPage: false),
                      ),
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
