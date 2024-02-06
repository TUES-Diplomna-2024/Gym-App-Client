import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/padded_adaptive_slider.dart';
import 'package:gym_app_client/utils/constants/signup_constants.dart';

class WeightFormField extends PaddedAdaptiveSlider {
  WeightFormField({
    super.key,
    required double selectedWeight,
    required void Function(double)? onWeightChanged,
    required EdgeInsets padding,
  }) : super(
          value: selectedWeight,
          min: SignUpConstants.minWeight,
          max: SignUpConstants.maxWeight,
          displayText: "Weight: ${selectedWeight.round()} kg",
          onChanged: onWeightChanged,
          padding: padding,
        );
}
