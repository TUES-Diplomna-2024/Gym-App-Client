import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/common/custom_app_bar.dart';
import 'package:gym_app_client/utils/forms/signin_form.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Welcome Back"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SignInForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                onEmailChanged: (String value) {
                  if (mounted) setState(() => _emailController.text = value);
                },
                onPasswordChanged: (String value) {
                  if (mounted) setState(() => _passwordController.text = value);
                },
                isPasswordVisible: _isPasswordVisible,
                onPasswordVisibilityChanged: () {
                  if (mounted) {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  }
                },
                formFieldPadding:
                    const EdgeInsets.only(left: 40, right: 40, bottom: 25),
                formButtonPadding: const EdgeInsets.only(left: 40, right: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
