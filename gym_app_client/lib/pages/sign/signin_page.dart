import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/form_page.dart';
import 'package:gym_app_client/utils/forms/signin_form.dart';

class SignInPage extends FormPage {
  SignInPage({super.key})
      : super(
          title: "Welcome Back",
          form: SignInForm(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 25),
          ),
        );
}
