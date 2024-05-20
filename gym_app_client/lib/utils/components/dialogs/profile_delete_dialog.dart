import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/fields/form/password_form_field.dart';

class ProfileDeleteDialog extends StatefulWidget {
  final bool isPasswordRequired;
  final String? userId;
  final void Function()? onUpdate;

  ProfileDeleteDialog({
    super.key,
    this.isPasswordRequired = true,
    this.userId,
    this.onUpdate,
  }) : assert((!isPasswordRequired &&
                userId != null &&
                userId.isNotEmpty &&
                onUpdate != null) ||
            (isPasswordRequired && userId == null && onUpdate == null));

  @override
  State<ProfileDeleteDialog> createState() => _ProfileDeleteDialogState();
}

class _ProfileDeleteDialogState extends State<ProfileDeleteDialog> {
  final _userService = UserService();

  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _handleProfileDeletion() {
    if (!widget.isPasswordRequired) {
      _userService.deleteUserById(widget.userId!).then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.isSuccessful && context.mounted) {
            widget.onUpdate!();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } else if (serviceResult.shouldSignOutUser) {
            _userService.signOut(context);
          }
        },
      );
    } else if (_fieldKey.currentState?.validate() ?? false) {
      _userService.deleteCurrUser(_passwordController.text).then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.shouldSignOutUser) {
            _userService.signOut(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text("Delete Account"),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              widget.isPasswordRequired
                  ? "Are you absolutely sure you want to delete your account? This action is permanent and cannot be undone! To proceed with deletion, please provide your password!"
                  : "Are you absolutely sure you want to delete this account? This action is permanent and cannot be undone!",
              style: TextStyle(color: Colors.red.shade500),
            ),
          ),
          const SizedBox(height: 30),
          if (widget.isPasswordRequired) ...{
            PasswordFormField(
              fieldKey: _fieldKey,
              passwordController: _passwordController,
              isPasswordVisible: _isPasswordVisible,
              onPasswordVisibilityChanged: () {
                if (mounted) {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                }
              },
              padding: const EdgeInsets.only(left: 10, right: 10),
            )
          },
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _handleProfileDeletion,
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red.shade400),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
