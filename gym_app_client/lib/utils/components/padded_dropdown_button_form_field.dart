import 'package:flutter/material.dart';

class PaddedDropdownButtonFormField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final InputDecoration? decoration;
  final EdgeInsetsGeometry padding;

  const PaddedDropdownButtonFormField({
    super.key,
    required this.items,
    required this.onChanged,
    required this.validator,
    required this.decoration,
    this.padding = const EdgeInsets.only(left: 15, right: 15, bottom: 25),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DropdownButtonFormField<T>(
        items: items,
        onChanged: onChanged,
        validator: validator,
        decoration: decoration,
      ),
    );
  }
}