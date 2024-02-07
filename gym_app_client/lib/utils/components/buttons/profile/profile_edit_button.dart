import 'package:flutter/material.dart';

class ProfileEditButton extends ElevatedButton {
  ProfileEditButton({
    super.key,
  }) : super(
          onPressed: () => debugPrint("Here 1"),
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade400),
          child: const Text("Edit"),
        );
}
