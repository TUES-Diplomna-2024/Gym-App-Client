import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/padded_adaptive_slider.dart';
import 'package:gym_app_client/utils/constants/signup_constants.dart';

class HeightFormField extends PaddedAdaptiveSlider {
  HeightFormField({
    super.key,
    required double selectedHeight,
    required void Function(double)? onHeightChanged,
    required EdgeInsets padding,
  }) : super(
          value: selectedHeight,
          min: SignUpConstants.minHeight,
          max: SignUpConstants.maxHeight,
          displayText: "Height: ${selectedHeight.round()} cm",
          onChanged: onHeightChanged,
          padding: padding,
        );
}
