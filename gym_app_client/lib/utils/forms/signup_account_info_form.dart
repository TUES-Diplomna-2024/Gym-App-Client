import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/email_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/password_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/confirm_password_form_field.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';

class SignUpAccountInfoForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final EdgeInsets formPadding;
  final EdgeInsets betweenFieldsPadding;

  const SignUpAccountInfoForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.formPadding,
    required this.betweenFieldsPadding,
  });

  @override
  State<SignUpAccountInfoForm> createState() => _SignUpAccountInfoFormState();
}

class _SignUpAccountInfoFormState extends State<SignUpAccountInfoForm> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.formPadding,
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NameFormField(
              nameController: widget.usernameController,
              label: "Username",
              hintText: "Enter your username",
              prefixIcon: Icons.person_outline,
              minLength: UserConstants.minUsernameLength,
              maxLength: UserConstants.maxUsernameLength,
              padding: widget.betweenFieldsPadding,
            ),
            EmailFormField(
              emailController: widget.emailController,
              padding: widget.betweenFieldsPadding,
            ),
            PasswordFormField(
              passwordController: widget.passwordController,
              isPasswordVisible: _isPasswordVisible,
              onPasswordVisibilityChanged: () {
                if (mounted) {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                }
              },
              padding: widget.betweenFieldsPadding,
            ),
            ConfirmPasswordFormField(
              passwordController: widget.passwordController,
              isConfirmPasswordVisible: _isConfirmPasswordVisible,
              onConfirmPasswordVisibilityChanged: () {
                if (mounted) {
                  setState(() =>
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                }
              },
              padding: widget.betweenFieldsPadding,
            ),
          ],
        ),
      ),
    );
  }
}
