import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/models/user/user_signin_model.dart';

class SignInSubmitButton extends StatelessWidget {
  final UserService _userService = UserService();
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SignInSubmitButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  void _handleSignIn(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      UserSignInModel userData = UserSignInModel(
        email: emailController.text,
        password: passwordController.text,
      );

      _userService.signIn(userData).then(
        (serviceResult) {
          serviceResult.showPopUp(context);

          if (serviceResult.isSuccessful && context.mounted) {
            Navigator.of(context).pushReplacementNamed("/");
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleSignIn(context),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: const Text(
        "Sign In",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
