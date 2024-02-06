import 'package:flutter/material.dart';

class PaddedAdaptiveSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String displayText;
  final void Function(double)? onChanged;
  final EdgeInsets padding;

  const PaddedAdaptiveSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.displayText,
    required this.onChanged,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          Center(
            child: Text(displayText),
          ),
          Slider.adaptive(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
