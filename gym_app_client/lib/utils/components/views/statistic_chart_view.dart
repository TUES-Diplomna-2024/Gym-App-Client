import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gym_app_client/utils/common/enums/statistic_measurement.dart';
import 'package:gym_app_client/utils/common/enums/statistic_period.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/db_api/models/exercise/statistic_data_point.dart';
import 'package:gym_app_client/utils/constants/statistic_constants.dart';

class StatisticChartView extends StatelessWidget {
  final StatisticPeriod timePeriod;
  final StatisticMeasurement measurement;
  late final List<charts.Series<StatisticDataPoint, DateTime>> seriesList;

  StatisticChartView({
    super.key,
    required List<StatisticDataPoint> dataPoints,
    required this.timePeriod,
    required this.measurement,
  }) {
    seriesList = _getSeries(dataPoints);
  }

  List<charts.Series<StatisticDataPoint, DateTime>> _getSeries(
      List<StatisticDataPoint> dataPoints) {
    return [
      charts.Series<StatisticDataPoint, DateTime>(
        id: measurement.name,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (StatisticDataPoint point, _) => point.date,
        measureFn: (StatisticDataPoint point, _) => point.value,
        data: dataPoints,
      )
    ];
  }

  charts.TimeSeriesChart _getChart() {
    return charts.TimeSeriesChart(
      seriesList,
      animate: false,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: const charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
        ),
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
          (num? value) {
            if (measurement == StatisticMeasurement.duration) {
              final Duration duration = Duration(seconds: value?.toInt() ?? 0);
              return durationToString(duration);
            }

            return value.toString();
          },
        ),
      ),
    );
  }

  String _getChartTitle() {
    String normalizedTimePeriod = StatisticConstants.periods[timePeriod]!;
    String normalizedMeasurement = capitalizeFirstLetter(measurement.name);

    String endOfTitle = timePeriod == StatisticPeriod.all
        ? "Based On All Records"
        : "Over The Last $normalizedTimePeriod";

    return "$normalizedMeasurement $endOfTitle";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(23),
          child: Column(
            children: [
              Text(
                _getChartTitle(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Expanded(child: _getChart()),
            ],
          ),
        ),
      ),
    );
  }
}
