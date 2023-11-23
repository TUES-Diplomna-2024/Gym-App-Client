import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/constants/signup_constants.dart';
import 'package:gym_app_client/utils/constants/app_regexes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bDateController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _cPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: _buildSignUpForm(),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
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
              "Sign Up",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          // Username
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                label: Text("Username"),
                prefixIcon: Icon(Icons.person_outline),
                hintText: "Enter your username",
                filled: true,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Username cannot be empty";
                } else if (value.length < SignUpConstants.minUsernameLength ||
                    value.length > SignUpConstants.maxUsernameLength) {
                  return "Username must be between ${SignUpConstants.minUsernameLength} and ${SignUpConstants.maxUsernameLength} characters";
                }

                setState(() => _usernameController.text = value);
                return null;
              },
            ),
          ),
          // Email
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: TextFormField(
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
          ),
          // Birth Date
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: TextFormField(
              controller: _bDateController,
              decoration: const InputDecoration(
                label: Text("Birth Date"),
                filled: true,
                prefixIcon: Icon(Icons.calendar_month_outlined),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please select your birth date";
                }

                return null;
              },
              readOnly: true,
              onTap: () => _selectDate(),
            ),
          ),
          // Password
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: TextFormField(
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
          ),
          // Confirm Password
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: TextFormField(
              decoration: InputDecoration(
                label: const Text("Confirm Password"),
                filled: true,
                prefixIcon: const Icon(Icons.lock_outline),
                hintText: "Please confirm your password",
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _cPasswordVisible = !_cPasswordVisible);
                  },
                  icon: _cPasswordVisible
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined),
                ),
              ),
              obscureText: !_cPasswordVisible,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please re-enter your password";
                } else if (_passwordController.text != value) {
                  return "The entered passwords do not match";
                }

                return null;
              },
            ),
          ),
          // Create account button
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  debugPrint("Successful submit!");

                  var registerData = {
                    "username": _usernameController.text,
                    "email": _emailController.text,
                    "bDate": _bDateController.text,
                    "password": _passwordController.text,
                  };

                  debugPrint(registerData.toString());
                } else {
                  debugPrint("Failed submittion!");
                }
              },
              child: const Text('Create account'),
            ),
          ),
          // Sign in page reference
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  debugPrint("-> Sign in page");
                },
                child: const Text(
                  "Sign in",
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
    _usernameController.dispose();
    _emailController.dispose();
    _bDateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime currDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currDate,
      firstDate: DateTime(currDate.year - SignUpConstants.allowableYearsRange),
      lastDate: currDate,
    );

    if (pickedDate != null) {
      setState(
        () => _bDateController.text = pickedDate.toString().split(" ")[0],
      );
    }
  }
}
