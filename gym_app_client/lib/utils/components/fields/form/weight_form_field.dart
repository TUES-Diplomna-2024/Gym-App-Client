import 'package:gym_app_client/utils/components/fields/form/padded_adaptive_slider.dart';
import 'package:gym_app_client/utils/constants/user_constants.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class WeightFormField extends PaddedAdaptiveSlider {
  WeightFormField({
    super.key,
    required double selectedWeight,
    required void Function(double)? onWeightChanged,
    required super.padding,
  }) : super(
          value: selectedWeight,
          min: UserConstants.minWeight,
          max: UserConstants.maxWeight,
          displayText: "Weight: ${getWeightString(selectedWeight)}",
          onChanged: onWeightChanged,
        );
}
