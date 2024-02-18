import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';
import 'package:gym_app_client/utils/forms/signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackLeadingAppBar(title: "Create Account", context: context),
      body: Center(
        child: SignUpForm(
          padding:
              const EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 25),
        ),
      ),
    );
  }
}
