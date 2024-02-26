import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';
import 'package:gym_app_client/utils/constants/statistic_constants.dart';

class StatisticMeasurementFormField
    extends PaddedDropdownButtonFormField<String> {
  StatisticMeasurementFormField({
    super.key,
    required void Function(String?) onMeasurementChanged,
  }) : super(
          padding: const EdgeInsets.all(0),
          decoration: const InputDecoration(
            label: Text("Measurement"),
            filled: true,
            prefixIcon: Icon(Icons.calendar_month_outlined),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onMeasurementChanged,
          items: StatisticConstants.measurements
              .map((String m) => DropdownMenuItem(
                    value: m.toLowerCase(),
                    child: Text(m),
                  ))
              .toList(),
          validator: null,
        );
}
