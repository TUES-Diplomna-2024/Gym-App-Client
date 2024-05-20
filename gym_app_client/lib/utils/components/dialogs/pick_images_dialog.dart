import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/constants/image_constants.dart';
import 'package:image_picker/image_picker.dart';

class PickImagesDialog extends StatelessWidget {
  final _imagePicker = ImagePicker();
  final void Function(List<XFile>) onSelect;

  PickImagesDialog({
    super.key,
    required this.onSelect,
  });

  Future<void> _setFileList() async {
    try {
      final List<XFile> pickedFileList = await _imagePicker.pickMultiImage(
        maxWidth: ImageConstants.maxWidth,
        maxHeight: ImageConstants.maxHeight,
      );

      onSelect(pickedFileList);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text("Select Images"),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Select'),
          onPressed: () {
            _setFileList().then((_) {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
          },
        ),
      ],
    );
  }
}
