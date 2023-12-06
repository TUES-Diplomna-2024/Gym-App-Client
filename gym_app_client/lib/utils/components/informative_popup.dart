import 'package:flutter/material.dart';

class InformativePopUp extends SnackBar {
  InformativePopUp({
    super.key,
    required String message,
    required Color color,
  }) : super(
          content: Center(
            child: Text(message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        );
}
