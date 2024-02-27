import 'package:flutter/material.dart';

class ContentField extends StatelessWidget {
  final IconData? fieldIcon;
  final String? fieldName;
  final dynamic fieldValue;
  final EdgeInsets padding;
  final EdgeInsets decorationPadding;
  final TextOverflow valueOverflow;
  final bool isMultiline;
  final bool isFieldNameCentered;

  const ContentField({
    super.key,
    this.fieldIcon,
    this.fieldName,
    required this.fieldValue,
    this.isMultiline = false,
    this.isFieldNameCentered = false,
    this.valueOverflow = TextOverflow.clip,
    this.decorationPadding = const EdgeInsets.all(15),
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
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _getFieldNameWidget() {
    return Expanded(
      child: Text(
        fieldName!,
        style: const TextStyle(fontSize: 16.0),
        textAlign: isFieldNameCentered ? TextAlign.center : null,
      ),
    );
  }

  Widget _getContainerChild() {
    if (isMultiline) {
      return Column(
        children: [
          if (fieldName != null) ...{
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (fieldIcon != null) ...{
                    Icon(fieldIcon),
                    const SizedBox(width: 20)
                  },
                  _getFieldNameWidget(),
                ],
              ),
            ),
          },
          _getFieldValueWidget(),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (fieldName != null) ...{
            if (fieldIcon != null) ...{
              Icon(fieldIcon),
              const SizedBox(width: 20)
            },
            _getFieldNameWidget(),
            if (fieldIcon == null) const SizedBox(width: 30),
          },
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
