import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';
import 'package:gym_app_client/utils/constants/app_regexes.dart';

class EmailFormField extends PaddedTextFormField {
  EmailFormField({
    super.key,
    required TextEditingController emailController,
    required void Function(String) onEmailChanged,
    required EdgeInsets padding,
  }) : super(
          controller: emailController,
          padding: padding,
          decoration: const InputDecoration(
            label: Text("Email"),
            filled: true,
            prefixIcon: Icon(Icons.mail_outline),
            hintText: "Enter your email",
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Email cannot be empty";
            } else if (!AppRegexes.isValidEmail(value)) {
              return "Invalid email format";
            }

            onEmailChanged(value);
            return null;
          },
        );
}
