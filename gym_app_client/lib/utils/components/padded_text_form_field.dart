import 'package:flutter/material.dart';

class PaddedTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration decoration;
  final bool readOnly;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final EdgeInsetsGeometry padding;

  const PaddedTextFormField({
    super.key,
    required this.decoration,
    required this.validator,
    this.controller,
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
        controller: controller,
        decoration: decoration,
        validator: validator,
        readOnly: readOnly,
        obscureText: obscureText,
        onTap: onTap,
      ),
    );
  }
}
