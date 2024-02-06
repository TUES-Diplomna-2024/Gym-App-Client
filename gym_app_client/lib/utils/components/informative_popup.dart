import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/popup_info.dart';

class InformativePopUp extends SnackBar {
  InformativePopUp({
    super.key,
    required PopUpInfo info,
  }) : super(
          content: Center(
            child: Text(info.message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ),
          backgroundColor: info.color,
          duration: const Duration(seconds: 3),
        );
}
