import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    required String title,
    Widget? leading,
    PreferredSizeWidget? bottom,
  }) : super(
          title: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: leading,
          bottom: bottom,
        );
}
