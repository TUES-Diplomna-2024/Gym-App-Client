import 'package:flutter/material.dart';

class ExerciseImageView extends StatelessWidget {
  final Image image;

  const ExerciseImageView({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: Center(
          child: Stack(
            children: [
              Center(child: image),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
