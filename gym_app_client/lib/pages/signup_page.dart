import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/constants/signup_constants.dart';
import 'package:gym_app_client/utils/forms/signup_account_info_form.dart';
import 'package:gym_app_client/utils/forms/signup_biometric_info_form.dart';
import 'package:gym_app_client/utils/components/buttons/form/signup_submit_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _accountInfoFormKey = GlobalKey<FormState>();
  final _biometricInfoFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();

  String _selectedGender = "";
  double _selectedHeight = SignUpConstants.defaultHeight;
  double _selectedWeight = SignUpConstants.defaultWeight;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  int _currStep = 0;
  StepState _accountInfoCurrState = StepState.editing;
  StepState _biometricInfoCurrState = StepState.indexed;

  @override
  Widget build(BuildContext context) {
    final steps = _getStepList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Account",
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_accountInfoFormKey.currentState!.validate()) {
                        setState(() {
                          _currStep += 1;
                          _accountInfoCurrState = StepState.complete;
                          _biometricInfoCurrState =
                              _biometricInfoCurrState == StepState.indexed
                                  ? StepState.editing
                                  : _biometricInfoCurrState;
                        });
                      } else {
                        setState(() => _accountInfoCurrState = StepState.error);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ];
            } else {
              rowChildren = [
                // Prev
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currStep -= 1;
                        _accountInfoCurrState = StepState.editing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Prev",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                // Sign up
                Expanded(
                  child: SignUpSubmitButton(
                    formKey: _biometricInfoFormKey,
                    usernameController: _usernameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    birthDateController: _birthDateController,
                    selectedGender: _selectedGender,
                    selectedHeight: _selectedHeight,
                    selectedWeight: _selectedWeight,
                    onSuccessfulForm: () => setState(
                        () => _biometricInfoCurrState = StepState.complete),
                    onFailedForm: () => setState(
                        () => _biometricInfoCurrState = StepState.error),
                  ),
                ),
              ];
            }

            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Row(children: rowChildren),
                  const SizedBox(height: 30),
                  // Sign up page reference
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

  List<Step> _getStepList() => [
        Step(
          title: const Text("Account Info"),
          state: _accountInfoCurrState,
          isActive: _currStep >= 0,
          content: SignUpAccountInfoForm(
            formKey: _accountInfoFormKey,
            usernameController: _usernameController,
            emailController: _emailController,
            passwordController: _passwordController,
            onUsernameChanged: (String value) =>
                setState(() => _usernameController.text = value),
            onEmailChanged: (String value) =>
                setState(() => _emailController.text = value),
            onPasswordChanged: (String value) =>
                setState(() => _passwordController.text = value),
            isPasswordVisible: _isPasswordVisible,
            onPasswordVisibilityChanged: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
            isConfirmPasswordVisible: _isConfirmPasswordVisible,
            onConfirmPasswordVisibilityChanged: () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
            formFieldPadding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 25),
          ),
        ),
        Step(
          title: const Text("Biometric Info"),
          state: _biometricInfoCurrState,
          isActive: _currStep == 1,
          content: SignUpBiometricInfoForm(
            context: context,
            formKey: _biometricInfoFormKey,
            birthDateController: _birthDateController,
            selectedHeight: _selectedHeight,
            selectedWeight: _selectedWeight,
            onBirthDateChanged: (String value) =>
                setState(() => _birthDateController.text = value),
            onGenderChanged: (String? value) =>
                setState(() => _selectedGender = value!),
            onHeightChanged: (double value) =>
                setState(() => _selectedHeight = value),
            onWeightChanged: (double value) =>
                setState(() => _selectedWeight = value),
            formFieldPadding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 25),
          ),
        )
      ];

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();

    super.dispose();
  }
}
