import 'package:flutter/material.dart';

abstract class DeleteItemDialog extends StatelessWidget {
  final BuildContext context;
  final String itemType;

  const DeleteItemDialog({
    super.key,
    required this.context,
    required this.itemType,
  }) : assert(itemType.length > 1);

  void handleItemDeletion();

  String _getItemTypeAsTitle() =>
      "${itemType[0].toUpperCase()}${itemType.substring(1)}";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text("Delete ${_getItemTypeAsTitle()}"),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Text(
          "Are you absolutely sure you want to delete this $itemType? This action is permanent and cannot be undone!",
          style: TextStyle(color: Colors.red.shade500),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: handleItemDeletion,
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red.shade400),
          ),
        ),
      ],
    );
  }
}
