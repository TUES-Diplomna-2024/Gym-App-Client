import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';
import 'package:gym_app_client/utils/constants/signup_constants.dart';

class UsernameFormField extends PaddedTextFormField {
  UsernameFormField({
    super.key,
    required TextEditingController usernameController,
    required void Function(String) onUsernameChanged,
    required EdgeInsets padding,
  }) : super(
          controller: usernameController,
          padding: padding,
          decoration: const InputDecoration(
            label: Text("Username"),
            prefixIcon: Icon(Icons.person_outline),
            hintText: "Enter your username",
            filled: true,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Username cannot be empty";
            } else if (value.length < SignUpConstants.minUsernameLength ||
                value.length > SignUpConstants.maxUsernameLength) {
              return "Username must be between ${SignUpConstants.minUsernameLength} and ${SignUpConstants.maxUsernameLength} characters";
            }

            onUsernameChanged(value);
            return null;
          },
        );
}
