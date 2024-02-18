import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/buttons/sign/signup_submit_button.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';
import 'package:gym_app_client/utils/forms/signup_account_info_form.dart';
import 'package:gym_app_client/utils/forms/signup_biometric_info_form.dart';

class SignUpForm extends StatefulWidget {
  late final EdgeInsets formPadding;
  late final EdgeInsets betweenFieldsPadding;

  SignUpForm({
    super.key,
    required EdgeInsets padding,
  }) {
    formPadding = EdgeInsets.only(
      top: padding.top,
      left: padding.left,
      right: padding.right,
    );

    betweenFieldsPadding = EdgeInsets.only(bottom: padding.bottom);
  }

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _accountInfoFormKey = GlobalKey<FormState>();
  final _biometricInfoFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();

  String _selectedGender = "";
  double _selectedHeight = UserConstants.defaultHeight;
  double _selectedWeight = UserConstants.defaultWeight;

  int _currStep = 0;
  StepState _accountInfoCurrState = StepState.editing;
  StepState _biometricInfoCurrState = StepState.indexed;

  List<Step> _getStepList() {
    return [
      Step(
        title: const Text("Account Info"),
        state: _accountInfoCurrState,
        isActive: _currStep >= 0,
        content: SignUpAccountInfoForm(
          formKey: _accountInfoFormKey,
          usernameController: _usernameController,
          emailController: _emailController,
          passwordController: _passwordController,
          formPadding: widget.formPadding,
          betweenFieldsPadding: widget.betweenFieldsPadding,
        ),
      ),
      Step(
        title: const Text("Biometric Info"),
        state: _biometricInfoCurrState,
        isActive: _currStep == 1,
        content: SignUpBiometricInfoForm(
          formKey: _biometricInfoFormKey,
          birthDateController: _birthDateController,
          selectedHeight: _selectedHeight,
          selectedWeight: _selectedWeight,
          onGenderChanged: (String? value) {
            if (mounted) setState(() => _selectedGender = value!);
          },
          onHeightChanged: (double value) {
            if (mounted) setState(() => _selectedHeight = value);
          },
          onWeightChanged: (double value) {
            if (mounted) setState(() => _selectedWeight = value);
          },
          formPadding: widget.formPadding,
          betweenFieldsPadding: widget.betweenFieldsPadding,
        ),
      )
    ];
  }

  Widget _getStepperControls() {
    late List<Widget> rowChildren;

    if (_currStep == 0) {
      rowChildren = [
        // Next
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (!mounted) return;

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
            child: const Text("Next", style: TextStyle(fontSize: 16)),
          ),
        ),
      ];
    } else {
      rowChildren = [
        // Prev
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              if (mounted) {
                setState(() {
                  _currStep -= 1;
                  _accountInfoCurrState = StepState.editing;
                });
              }
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text("Prev", style: TextStyle(fontSize: 16)),
          ),
        ),
        // Sign Up
        const SizedBox(width: 30),
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
            onSuccessfulForm: () {
              if (mounted) {
                setState(() => _biometricInfoCurrState = StepState.complete);
              }
            },
            onFailedForm: () {
              if (mounted) {
                setState(() => _biometricInfoCurrState = StepState.error);
              }
            },
          ),
        ),
      ];
    }

    return Padding(
      padding: EdgeInsets.only(
        left: widget.formPadding.left,
        right: widget.formPadding.right,
      ),
      child: Row(children: rowChildren),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getStepList();

    return Stepper(
      controlsBuilder: (_, __) => _getStepperControls(),
      physics: const ClampingScrollPhysics(),
      type: StepperType.horizontal,
      currentStep: _currStep,
      steps: steps,
    );
  }
}
