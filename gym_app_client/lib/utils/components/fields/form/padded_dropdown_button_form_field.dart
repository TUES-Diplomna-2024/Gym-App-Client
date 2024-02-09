import 'package:flutter/material.dart';

class PaddedDropdownButtonFormField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final T? defaultItem;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final InputDecoration? decoration;
  final EdgeInsets padding;

  const PaddedDropdownButtonFormField({
    super.key,
    required this.items,
    this.defaultItem,
    required this.onChanged,
    required this.validator,
    required this.decoration,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DropdownButtonFormField<T>(
        items: items,
        value: defaultItem,
        onChanged: onChanged,
        validator: validator,
        decoration: decoration,
      ),
    );
  }
}
