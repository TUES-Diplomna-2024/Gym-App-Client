import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/statistic_period.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_dropdown_button_form_field.dart';
import 'package:gym_app_client/utils/constants/statistic_constants.dart';

class TimePeriodFormField
    extends PaddedDropdownButtonFormField<StatisticPeriod> {
  TimePeriodFormField({
    super.key,
    required void Function(StatisticPeriod?) onTimePeriodChanged,
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
          items: StatisticPeriod.values
              .map((period) => DropdownMenuItem(
                    value: period,
                    child: Text(StatisticConstants.periods[period]!),
                  ))
              .toList(),
          validator: null,
        );
}
