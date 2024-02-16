import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';
import 'package:gym_app_client/utils/components/common/informative_popup.dart';

class SignUpSubmitButton extends StatelessWidget {
  final UserService _userService = UserService();
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController birthDateController;
  final String selectedGender;
  final double selectedHeight;
  final double selectedWeight;
  final void Function() onSuccessfulForm;
  final void Function() onFailedForm;

  SignUpSubmitButton({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.birthDateController,
    required this.selectedGender,
    required this.selectedHeight,
    required this.selectedWeight,
    required this.onSuccessfulForm,
    required this.onFailedForm,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          onSuccessfulForm();

          UserSignUpModel userData = UserSignUpModel(
            username: usernameController.text,
            email: emailController.text,
            password: passwordController.text,
            birthDate: birthDateController.text,
            gender: selectedGender,
            height: selectedHeight,
            weight: selectedWeight,
          );

          var result = await _userService.signUp(userData);

          if (context.mounted) {
            final popup = InformativePopUp(info: result);

            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(popup);
          }
        } else {
          onFailedForm();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: const Text(
        "Sign up",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
