import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/models/user/user_signin_model.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';

class SignInSubmitButton extends StatelessWidget {
  late final UserService userService;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final EdgeInsetsGeometry padding;

  SignInSubmitButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.padding,
  }) {
    userService = UserService();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: padding,
        child: ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              UserSignInModel userData = UserSignInModel(
                email: emailController.text,
                password: passwordController.text,
              );

              var result = await userService.signIn(userData);

              if (context.mounted) {
                final popup = InformativePopUp(info: result);

                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(popup);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            "Sign in",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
