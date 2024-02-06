import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/forms/form_buttons/signin_submit_button.dart';
import 'package:gym_app_client/utils/forms/form_fields/email_form_field.dart';
import 'package:gym_app_client/utils/forms/form_fields/password_form_field.dart';

class SignInForm extends Form {
  SignInForm({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool isPasswordVisible,
    required void Function(String) onEmailChanged,
    required void Function(String) onPasswordChanged,
    required void Function() onPasswordVisibilityChanged,
    required EdgeInsetsGeometry formFieldPadding,
    required EdgeInsetsGeometry formButtonPadding,
  }) : super(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EmailFormField(
                emailController: emailController,
                onEmailChanged: onEmailChanged,
                padding: formFieldPadding,
              ),
              PasswordFormField(
                passwordController: passwordController,
                isPasswordVisible: isPasswordVisible,
                onPasswordVisibilityChanged: onPasswordVisibilityChanged,
                onPasswordChanged: onPasswordChanged,
                padding: formFieldPadding,
              ),
              SignInSubmitButton(
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                padding: formButtonPadding,
              )
            ],
          ),
        );
}
