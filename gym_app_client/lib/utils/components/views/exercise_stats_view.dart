import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_stats_model.dart';

class ExerciseStatsView extends StatelessWidget {
  final ExerciseStatsModel stats;

  const ExerciseStatsView({
    super.key,
    required this.stats,
  });

  Widget _getLineChart() {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: stats.getChartSpots(),
              isCurved: false,
              color: Colors.red,
            ),
          ],
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey, width: 1),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: leftTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: leftTitleWidgets,
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = "$value";

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getLineChart();
  }
}
