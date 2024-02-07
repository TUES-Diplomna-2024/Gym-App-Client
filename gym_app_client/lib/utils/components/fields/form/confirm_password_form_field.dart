import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';

class ConfirmPasswordFormField extends PaddedTextFormField {
  ConfirmPasswordFormField({
    super.key,
    required TextEditingController passwordController,
    required bool isConfirmPasswordVisible,
    required void Function() onConfirmPasswordVisibilityChanged,
    required EdgeInsets padding,
  }) : super(
          padding: padding,
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
              onPressed: () => onConfirmPasswordVisibilityChanged(),
              icon: isConfirmPasswordVisible
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
            ),
          ),
          obscureText: !isConfirmPasswordVisible,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please re-enter your password";
            } else if (passwordController.text != value) {
              return "The entered passwords do not match";
            }

            return null;
          },
        );
}
