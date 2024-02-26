import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';

class UnsignedDoubleFormField extends PaddedTextFormField {
  UnsignedDoubleFormField({
    super.key,
    required TextEditingController numberController,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    double? minValue,
    double? maxValue,
    bool isOptional = false,
    required EdgeInsets padding,
  }) : super(
          controller: numberController,
          padding: padding,
          decoration: InputDecoration(
            label: Text("$label${isOptional ? ' (Optional)' : ''}"),
            prefixIcon: Icon(prefixIcon),
            hintText: hintText,
            filled: true,
            enabledBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            NonNegativeDoubleFormatter(),
          ],
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return isOptional ? null : "$label cannot be empty";
            } else if (minValue != null && double.parse(value) < minValue) {
              return "$label cannot be smaller than $minValue";
            } else if (maxValue != null && double.parse(value) > maxValue) {
              return "$label cannot be bigger than $maxValue";
            }

            return null;
          },
        );
}

class NonNegativeDoubleFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(r'^(\d+(\.\d*)?|\.\d+)?$');
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
