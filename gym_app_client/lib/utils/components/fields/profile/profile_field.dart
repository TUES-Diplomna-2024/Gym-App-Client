import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final IconData fieldIcon;
  final String fieldName;
  final dynamic fieldValue;
  final EdgeInsets padding;

  const ProfileField({
    super.key,
    required this.fieldIcon,
    required this.fieldName,
    required this.fieldValue,
    required this.padding,
  });

  Widget getFieldValueWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          fieldValue.toString(),
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(fieldIcon),
            const SizedBox(width: 20),
            Expanded(
              child: Text(fieldName, style: const TextStyle(fontSize: 16.0)),
            ),
            Expanded(
              child: getFieldValueWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
