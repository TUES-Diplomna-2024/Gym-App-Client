import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/padded_adaptive_slider.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';

class WeightFormField extends PaddedAdaptiveSlider {
  WeightFormField({
    super.key,
    required double selectedWeight,
    required void Function(double)? onWeightChanged,
    required EdgeInsets padding,
  }) : super(
          value: selectedWeight,
          min: UserConstants.minWeight,
          max: UserConstants.maxWeight,
          displayText: "Weight: ${selectedWeight.toStringAsFixed(1)} kg",
          onChanged: onWeightChanged,
          padding: padding,
        );
}
