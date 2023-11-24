import 'package:flutter/material.dart';

class PaddedElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;

  const PaddedElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
