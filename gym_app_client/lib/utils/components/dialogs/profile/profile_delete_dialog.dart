import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/fields/form/password_form_field.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';

class ProfileDeleteDialog extends StatefulWidget {
  const ProfileDeleteDialog({super.key});

  @override
  State<ProfileDeleteDialog> createState() => _ProfileDeleteDialogState();
}

class _ProfileDeleteDialogState extends State<ProfileDeleteDialog> {
  final _userService = UserService();
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<bool> _handleProfileDeletion() async {
    if (_fieldKey.currentState?.validate() ?? false) {
      var result = await _userService.deleteCurrUser(_passwordController.text);

      if (context.mounted) {
        final popup = InformativePopUp(info: result.popUpInfo!);

        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }

      return true;
    }

    return false;
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
              "Are you absolutely sure you want to delete your account? This action is permanent and cannot be undone. To proceed with deletion, please provide your password.",
              style: TextStyle(color: Colors.red.shade500),
            ),
          ),
          const SizedBox(height: 30),
          PasswordFormField(
            fieldKey: _fieldKey,
            passwordController: _passwordController,
            onPasswordChanged: (String value) {
              if (mounted) setState(() => _passwordController.text = value);
            },
            isPasswordVisible: _isPasswordVisible,
            onPasswordVisibilityChanged: () {
              if (mounted) {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              }
            },
            padding: const EdgeInsets.only(left: 10, right: 10),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => _handleProfileDeletion().then((bool isDone) {
            if (isDone && mounted) Navigator.of(context).pop();
          }),
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
