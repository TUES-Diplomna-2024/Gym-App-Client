import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/common/informative_popup.dart';

class ServiceResult {
  final bool isSuccessful;
  final String message;
  final dynamic data;
  final bool shouldSignOutUser;

  ServiceResult.success({
    this.message = "",
    this.data,
    this.shouldSignOutUser = false,
  }) : isSuccessful = true;

  ServiceResult.fail({
    this.message = "",
    this.data,
    this.shouldSignOutUser = false,
  }) : isSuccessful = false;

  void showPopUp(BuildContext context) {
    if (context.mounted) {
      final popup = InformativePopUp(
        message: message,
        color: _getPopUpColor(),
      );

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(popup);
    }
  }

  Color _getPopUpColor() {
    return isSuccessful ? Colors.green.shade300 : Colors.red.shade400;
  }
}
