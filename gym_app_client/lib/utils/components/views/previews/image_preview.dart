import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final Image image;
  final void Function()? onClicked;
  final void Function()? onRemove;

  const ImagePreview({
    super.key,
    required this.image,
    this.onClicked,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(25),
      child: Stack(
        children: [
          GestureDetector(
            onTap: onClicked,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37),
              child: image,
            ),
          ),
          if (onRemove != null) ...{
            Positioned(
              left: 0,
              child: IconButton(
                onPressed: onRemove,
                color: Colors.red,
                icon: const Icon(Icons.delete),
              ),
            )
          },
        ],
      ),
    );
  }
}
