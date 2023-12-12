import 'package:flutter/material.dart';

class PaddedElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry padding;

  const PaddedElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.only(left: 15, right: 15, bottom: 25),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
