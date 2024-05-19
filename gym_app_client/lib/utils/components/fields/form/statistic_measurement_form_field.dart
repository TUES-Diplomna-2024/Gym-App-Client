import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/statistic_measurement.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';

class StatisticMeasurementFormField
    extends PaddedDropdownButtonFormField<StatisticMeasurement> {
  StatisticMeasurementFormField({
    super.key,
    required void Function(StatisticMeasurement?) onMeasurementChanged,
  }) : super(
          padding: const EdgeInsets.all(0),
          decoration: const InputDecoration(
            label: Text("Measurement"),
            filled: true,
            prefixIcon: Icon(Icons.show_chart),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onMeasurementChanged,
          items: StatisticMeasurement.values
              .map((measurement) => DropdownMenuItem(
                    value: measurement,
                    child: Text(capitalizeFirstLetter(measurement.name)),
                  ))
              .toList(),
          validator: null,
        );
}
