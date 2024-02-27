import 'package:gym_app_client/utils/components/fields/form/padded_adaptive_slider.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';

class HeightFormField extends PaddedAdaptiveSlider {
  HeightFormField({
    super.key,
    required double selectedHeight,
    required void Function(double)? onHeightChanged,
    required super.padding,
  }) : super(
          value: selectedHeight,
          min: UserConstants.minHeight,
          max: UserConstants.maxHeight,
          displayText: "Height: ${selectedHeight.toStringAsFixed(1)} cm",
          onChanged: onHeightChanged,
        );
}
