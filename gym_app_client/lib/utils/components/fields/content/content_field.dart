import 'package:flutter/material.dart';

class ContentField extends StatelessWidget {
  final IconData? fieldIcon;
  final String fieldName;
  final dynamic fieldValue;
  final EdgeInsets padding;
  final EdgeInsets decorationPadding;
  final TextOverflow valueOverflow;
  final bool isMultiline;

  const ContentField({
    super.key,
    this.fieldIcon,
    this.valueOverflow = TextOverflow.clip,
    this.decorationPadding = const EdgeInsets.all(15),
    this.isMultiline = false,
    required this.fieldName,
    required this.fieldValue,
    required this.padding,
  });

  Widget _getFieldValueWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          fieldValue.toString(),
          style: const TextStyle(fontSize: 16.0),
          overflow: valueOverflow,
        ),
      ),
    );
  }

  Widget _getContainerChild() {
    if (isMultiline) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (fieldIcon != null) ...{
                  Icon(fieldIcon),
                  const SizedBox(width: 20)
                },
                Expanded(
                  child:
                      Text(fieldName, style: const TextStyle(fontSize: 16.0)),
                ),
              ],
            ),
          ),
          _getFieldValueWidget(),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (fieldIcon != null) ...{
            Icon(fieldIcon),
            const SizedBox(width: 20)
          },
          Expanded(
            child: Text(fieldName, style: const TextStyle(fontSize: 16.0)),
          ),
          if (fieldIcon == null) const SizedBox(width: 30),
          Expanded(
            child: _getFieldValueWidget(),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        padding: decorationPadding,
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(5),
        ),
        child: _getContainerChild(),
      ),
    );
  }
}
