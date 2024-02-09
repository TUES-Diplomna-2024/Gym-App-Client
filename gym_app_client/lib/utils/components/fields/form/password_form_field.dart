import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';
import 'package:gym_app_client/utils/constants/app_regexes.dart';

class PasswordFormField extends PaddedTextFormField {
  PasswordFormField({
    super.key,
    GlobalKey<FormFieldState<String>>? fieldKey,
    required TextEditingController passwordController,
    required void Function(String) onPasswordChanged,
    required bool isPasswordVisible,
    required void Function() onPasswordVisibilityChanged,
    required EdgeInsets padding,
  }) : super(
          fieldKey: fieldKey,
          controller: passwordController,
          padding: padding,
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
              onPressed: () => onPasswordVisibilityChanged(),
              icon: isPasswordVisible
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
            ),
          ),
          obscureText: !isPasswordVisible,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password";
            } else if (value.length < UserConstants.minPasswordLength ||
                value.length > UserConstants.maxPasswordLength) {
              return "Password must be between ${UserConstants.minPasswordLength} and ${UserConstants.maxPasswordLength} characters";
            } else if (!AppRegexes.isValidPassword(value)) {
              return "Password must include at least one lowercase letter, \none uppercase letter, one digit, and one special character.";
            }

            onPasswordChanged(value);
            return null;
          },
        );
}
