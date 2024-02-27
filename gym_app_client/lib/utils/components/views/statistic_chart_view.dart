import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gym_app_client/utils/common/statistic_data_point.dart';
import 'package:gym_app_client/utils/constants/statistic_constants.dart';

class StatisticChartView extends StatelessWidget {
  final String timePeriod;
  final String measurement;
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
        id: measurement,
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
            if (measurement.toLowerCase() == "duration") {
              final Duration duration = Duration(seconds: value?.toInt() ?? 0);
              final String minutes =
                  (duration.inMinutes % 60).toString().padLeft(2, '0');
              final String seconds =
                  (duration.inSeconds % 60).toString().padLeft(2, '0');
              return '${duration.inHours}:$minutes:$seconds';
            }

            return value.toString();
          },
        ),
      ),
    );
  }

  String _getChartTitle() {
    String getNormalizedTimePeriod() {
      return StatisticConstants.periods.keys.firstWhere(
        (key) => StatisticConstants.periods[key] == timePeriod,
        orElse: () => "",
      );
    }

    String getNormalizedMeasurement() {
      return measurement.isNotEmpty
          ? "${measurement[0].toUpperCase()}${measurement.substring(1)}"
          : "";
    }

    String normalizedTimePeriod = getNormalizedTimePeriod();
    String normalizedMeasurement = getNormalizedMeasurement();

    if (normalizedTimePeriod.isEmpty || normalizedMeasurement.isEmpty) {
      return "";
    }

    String endOfTitle = normalizedTimePeriod == "All"
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
