import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/username_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/email_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/password_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/confirm_password_form_field.dart';

class SignUpAccountInfoForm extends Form {
  SignUpAccountInfoForm({
    required GlobalKey<FormState> formKey,
    required TextEditingController usernameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required void Function(String) onUsernameChanged,
    required void Function(String) onEmailChanged,
    required void Function(String) onPasswordChanged,
    required bool isPasswordVisible,
    required void Function() onPasswordVisibilityChanged,
    required bool isConfirmPasswordVisible,
    required void Function() onConfirmPasswordVisibilityChanged,
    required EdgeInsets formFieldPadding,
  }) : super(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UsernameFormField(
                  usernameController: usernameController,
                  onUsernameChanged: onUsernameChanged,
                  padding: formFieldPadding,
                ),
                EmailFormField(
                  emailController: emailController,
                  onEmailChanged: onEmailChanged,
                  padding: formFieldPadding,
                ),
                PasswordFormField(
                  passwordController: passwordController,
                  onPasswordChanged: onPasswordChanged,
                  isPasswordVisible: isPasswordVisible,
                  onPasswordVisibilityChanged: onPasswordVisibilityChanged,
                  padding: formFieldPadding,
                ),
                ConfirmPasswordFormField(
                  passwordController: passwordController,
                  isConfirmPasswordVisible: isConfirmPasswordVisible,
                  onConfirmPasswordVisibilityChanged:
                      onConfirmPasswordVisibilityChanged,
                  padding: formFieldPadding,
                ),
              ],
            ),
          ),
        );
}
