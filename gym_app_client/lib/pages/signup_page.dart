import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';

import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/padded_dropdown_button_form_field.dart';
import 'package:gym_app_client/utils/components/padded_text_form_field.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';

import 'package:gym_app_client/utils/constants/signup_constants.dart';
import 'package:gym_app_client/utils/constants/app_regexes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _userService = UserService();

  final _accountInfoFormKey = GlobalKey<FormState>();
  final _biometricInfoFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bDateController = TextEditingController();

  String _selectedGender = "";
  double _selectedHeight = SignUpConstants.defaultHeight;
  double _selectedWeight = SignUpConstants.defaultWeight;

  bool _passwordVisible = false;
  bool _cPasswordVisible = false;

  int _currStep = 0;
  StepState _accountInfoCurrState = StepState.editing;
  StepState _biometricInfoCurrState = StepState.indexed;

  @override
  Widget build(BuildContext context) {
    final steps = _getStepList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Stepper(
          controlsBuilder: (BuildContext context, _) {
            late List<Widget> rowChildren;

            if (_currStep == 0) {
              rowChildren = [
                // Next
                TextButton(
                  onPressed: () {
                    if (_accountInfoFormKey.currentState!.validate()) {
                      setState(() {
                        _currStep += 1;
                        _accountInfoCurrState = StepState.complete;
                        _biometricInfoCurrState = StepState.editing;
                      });
                    } else {
                      setState(() => _accountInfoCurrState = StepState.error);
                    }
                  },
                  child: const Text(
                    "NEXT",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ];
            } else {
              rowChildren = [
                // Prev
                TextButton(
                  onPressed: () {
                    if (_biometricInfoFormKey.currentState!.validate()) {
                      setState(() {
                        _currStep -= 1;
                        _accountInfoCurrState = StepState.editing;
                        _biometricInfoCurrState = StepState.editing;
                      });
                    } else {
                      setState(() => _biometricInfoCurrState = StepState.error);
                    }
                  },
                  child: const Text(
                    "PREV",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Submit
                TextButton(
                  onPressed: () async {
                    if (_biometricInfoFormKey.currentState!.validate()) {
                      setState(
                          () => _biometricInfoCurrState = StepState.complete);

                      UserSignUpModel userData = UserSignUpModel(
                        username: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        birthDate: _bDateController.text,
                        gender: _selectedGender,
                        height: _selectedHeight,
                        weight: _selectedWeight,
                      );

                      var result = await _userService.signUp(userData);

                      if (context.mounted) {
                        final InformativePopUp popup = InformativePopUp(
                          message: result.$1,
                          color: result.$2,
                        );

                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(popup);
                      }

                      debugPrint(result.toString());
                      debugPrint(userData.toJson().toString());
                    } else {
                      setState(() => _biometricInfoCurrState = StepState.error);
                    }
                  },
                  child: const Text(
                    "SUBMIT",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ];
            }

            return Row(
              mainAxisAlignment: _currStep == 0
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceAround,
              children: rowChildren,
            );
          },
          physics: const ClampingScrollPhysics(),
          type: StepperType.horizontal,
          currentStep: _currStep,
          steps: steps,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bDateController.dispose();

    super.dispose();
  }

  List<Step> _getStepList() => [
        Step(
          title: const Text("Account Info"),
          state: _accountInfoCurrState,
          isActive: _currStep >= 0,
          content: _buildAccountInfoForm(),
        ),
        Step(
          title: const Text("Biometric Info"),
          state: _biometricInfoCurrState,
          isActive: _currStep == 1,
          content: _buildBiometricInfoForm(),
        )
      ];

  Widget _buildAccountInfoForm() {
    return Form(
      key: _accountInfoFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Username
          PaddedTextFormField(
            controller: _usernameController,
            padding:
                const EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 25),
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
          // Confirm Password
          PaddedTextFormField(
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
        ],
      ),
    );
  }

  Widget _buildBiometricInfoForm() {
    return Form(
      key: _biometricInfoFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Birth Date
          PaddedTextFormField(
            controller: _bDateController,
            padding:
                const EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 25),
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
          // Gender
          PaddedDropdownButtonFormField(
            decoration: const InputDecoration(
              label: Text("Gender"),
              filled: true,
              prefixIcon: Icon(Icons.accessibility_new_outlined),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
            onChanged: (String? value) {
              setState(() => _selectedGender = value!);
            },
            items: SignUpConstants.genders
                .map((String gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Please select your gender";
              }

              return null;
            },
          ),
          // Height
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Column(
              children: [
                Center(
                  child: Text("Height: ${_selectedHeight.round()} cm"),
                ),
                Slider.adaptive(
                  value: _selectedHeight,
                  min: SignUpConstants.minHeight,
                  max: SignUpConstants.maxHeight,
                  onChanged: (double value) {
                    setState(() => _selectedHeight = value);
                  },
                ),
              ],
            ),
          ),
          // Weight
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Column(
              children: [
                Center(
                  child:
                      Text("Weight: ${_selectedWeight.toStringAsFixed(1)} kg"),
                ),
                Slider.adaptive(
                  value: _selectedWeight,
                  min: SignUpConstants.minWeight,
                  max: SignUpConstants.maxWeight,
                  onChanged: (double value) {
                    setState(() => _selectedWeight = value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
