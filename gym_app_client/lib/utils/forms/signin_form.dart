import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/email_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/password_form_field.dart';
import 'package:gym_app_client/utils/components/buttons/sign/signin_submit_button.dart';

class SignInForm extends StatefulWidget {
  late final EdgeInsets formPadding;
  late final EdgeInsets betweenFieldsPadding;

  SignInForm({
    super.key,
    required EdgeInsets padding,
  }) {
    formPadding = EdgeInsets.only(
      left: padding.left,
      right: padding.right,
    );

    betweenFieldsPadding = EdgeInsets.only(bottom: padding.bottom);
  }

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.formPadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EmailFormField(
              emailController: _emailController,
              padding: widget.betweenFieldsPadding,
            ),
            PasswordFormField(
              passwordController: _passwordController,
              isPasswordVisible: _isPasswordVisible,
              onPasswordVisibilityChanged: () {
                if (mounted) {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                }
              },
              padding: widget.betweenFieldsPadding,
            ),
            SignInSubmitButton(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
            ),
          ],
        ),
      ),
    );
  }
}
