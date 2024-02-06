import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text(
          "Welcome Back",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SignInForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                onEmailChanged: (String value) =>
                    setState(() => _emailController.text = value),
                onPasswordChanged: (String value) =>
                    setState(() => _passwordController.text = value),
                isPasswordVisible: _isPasswordVisible,
                onPasswordVisibilityChanged: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                formFieldPadding:
                    const EdgeInsets.only(left: 40, right: 40, bottom: 25),
                formButtonPadding: const EdgeInsets.only(left: 40, right: 40),
              ),
              const SizedBox(height: 30),
              // Sign up page reference
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  TextButton(
                    onPressed: () {
                      _emailController.clear();
                      _passwordController.clear();

                      ScaffoldMessenger.of(context).clearSnackBars();

                      Navigator.of(context).pushNamed("/signup");
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
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
