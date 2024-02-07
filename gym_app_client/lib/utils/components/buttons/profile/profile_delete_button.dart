import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/dialogs/profile/profile_delete_dialog.dart';

class ProfileDeleteButton extends ElevatedButton {
  ProfileDeleteButton({
    super.key,
    required BuildContext context,
  }) : super(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const ProfileDeleteDialog(),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
          child: const Text("Delete"),
        );
}
