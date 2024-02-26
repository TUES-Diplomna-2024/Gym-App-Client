import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaddedTextFormField extends StatelessWidget {
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final TextEditingController? controller;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final EdgeInsets padding;

  const PaddedTextFormField({
    super.key,
    this.fieldKey,
    this.maxLines = 1,
    required this.decoration,
    required this.validator,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        decoration: decoration,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        readOnly: readOnly,
        obscureText: obscureText,
        maxLines: maxLines,
        onTap: onTap,
      ),
    );
  }
}
