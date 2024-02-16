import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/common/custom_app_bar.dart';

class BackLeadingAppBar extends CustomAppBar {
  BackLeadingAppBar({
    super.key,
    required String title,
    required BuildContext context,
  }) : super(
          title: title,
          leading: IconButton(
            onPressed: () {
              if (context.mounted) Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        );
}
