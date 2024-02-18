import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';

class BirthDateFormField extends PaddedTextFormField {
  BirthDateFormField({
    super.key,
    required BuildContext context,
    required TextEditingController birthDateController,
    required EdgeInsets padding,
  }) : super(
          controller: birthDateController,
          padding: padding,
          decoration: const InputDecoration(
            label: Text("Birth Date"),
            filled: true,
            prefixIcon: Icon(Icons.calendar_month_outlined),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please select your birth date";
            }

            return null;
          },
          readOnly: true,
          onTap: () async {
            String? birthDate = await _selectDate(context);

            if (birthDate != null) birthDateController.text = birthDate;
          },
        );

  static Future<String?> _selectDate(BuildContext context) async {
    DateTime currDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currDate,
      firstDate: DateTime(currDate.year - UserConstants.allowableYearsRange),
      lastDate: currDate,
    );

    if (pickedDate != null) return pickedDate.toString().split(" ")[0];

    return null;
  }
}
