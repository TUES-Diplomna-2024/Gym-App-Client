import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';
import 'package:gym_app_client/utils/constants/statistic_constants.dart';

class TimePeriodFormField extends PaddedDropdownButtonFormField<String> {
  TimePeriodFormField({
    super.key,
    required void Function(String?) onTimePeriodChanged,
  }) : super(
          padding: const EdgeInsets.all(0),
          decoration: const InputDecoration(
            label: Text("Time Period"),
            filled: true,
            prefixIcon: Icon(Icons.calendar_month_outlined),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
          onChanged: onTimePeriodChanged,
          items: StatisticConstants.periods.keys
              .map((String periodName) => DropdownMenuItem(
                    value: StatisticConstants.periods[periodName],
                    child: Text(periodName),
                  ))
              .toList(),
          validator: null,
        );
}
