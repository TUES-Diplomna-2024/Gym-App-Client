import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_signin_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';

import 'package:gym_app_client/utils/components/padded_elevated_button.dart';
import 'package:gym_app_client/utils/components/padded_text_form_field.dart';
import 'package:gym_app_client/utils/constants/app_regexes.dart';
import 'package:gym_app_client/utils/constants/signup_constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _userService = UserService();

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: _buildSignInForm(),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Sign In",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          // Email
          PaddedTextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              label: Text("Email"),
              filled: true,
              prefixIcon: Icon(Icons.mail_outline),
              hintText: "Enter your email",
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Email cannot be empty";
              } else if (!AppRegexes.isValidEmail(value)) {
                return "Invalid email format";
              }

              setState(() => _emailController.text = value);
              return null;
            },
          ),
          // Password
          PaddedTextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              label: const Text("Password"),
              filled: true,
              prefixIcon: const Icon(Icons.lock_outline),
              hintText: "Enter your password",
              enabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _passwordVisible = !_passwordVisible);
                },
                icon: _passwordVisible
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
              ),
            ),
            obscureText: !_passwordVisible,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              } else if (value.length < SignUpConstants.minPasswordLength ||
                  value.length > SignUpConstants.maxPasswordLength) {
                return "Password must be between ${SignUpConstants.minPasswordLength} and ${SignUpConstants.maxPasswordLength} characters";
              } else if (!AppRegexes.isValidPassword(value)) {
                return "Password must include at least one lowercase letter, \none uppercase letter, one digit, and one special character.";
              }

              setState(() => _passwordController.text = value);
              return null;
            },
          ),
          // Login button
          PaddedElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                debugPrint("Successful submit!");

                UserSignInModel userData = UserSignInModel(
                  email: _emailController.text,
                  password: _passwordController.text,
                );

                var result = await _userService.signIn(userData);

                if (context.mounted) {
                  final InformativePopUp popup = InformativePopUp(
                    message: result.$1,
                    color: result.$2,
                  );

                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(popup);
                }

                debugPrint(userData.toJson().toString());
              } else {
                debugPrint("Failed submittion!");
              }
            },
            child: const Text('Login'),
          ),
          // Sign up page reference
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              TextButton(
                onPressed: () {
                  _emailController.clear();
                  _passwordController.clear();

                  ScaffoldMessenger.of(context).clearSnackBars();

                  Navigator.of(context).pushNamed("/signup");

                  debugPrint("-> Sign up page");
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ],
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
