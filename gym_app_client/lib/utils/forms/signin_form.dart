import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/email_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/password_form_field.dart';
import 'package:gym_app_client/utils/components/buttons/sign/signin_submit_button.dart';

class SignInForm extends Form {
  SignInForm({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool isPasswordVisible,
    required void Function(String) onEmailChanged,
    required void Function(String) onPasswordChanged,
    required void Function() onPasswordVisibilityChanged,
    required EdgeInsets formFieldPadding,
    required EdgeInsets formButtonPadding,
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
