import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_stats_model.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/views/statistic_chart_view.dart';

class ExerciseStatsView extends StatelessWidget {
  final ExerciseStatsModel stats;
  final String timePeriod;
  final String measurement;

  const ExerciseStatsView({
    super.key,
    required this.stats,
    required this.timePeriod,
    required this.measurement,
  });

  Row _getContentFieldRow(List<(String?, dynamic)> contentFieldsData) {
    List<Widget> fieldsWithSpacer = [];

    for (int i = 0; i < contentFieldsData.length; i++) {
      final field = ContentField(
        fieldName: contentFieldsData[i].$1,
        fieldValue: contentFieldsData[i].$2,
        isFieldNameCentered: true,
        isMultiline: true,
        padding: const EdgeInsets.only(bottom: 15),
      );

      fieldsWithSpacer.add(Expanded(child: field));

      if (i != contentFieldsData.length - 1) {
        fieldsWithSpacer.add(const SizedBox(width: 23));
      }
    }

    return Row(children: fieldsWithSpacer);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatisticChartView(
          dataPoints: stats.dataPoints,
          timePeriod: timePeriod,
          measurement: measurement,
        ),
        const SizedBox(height: 23),
        _getContentFieldRow([
          ("Total Sets", stats.totalSets),
          ("Total Reps", stats.totalReps),
        ]),
        _getContentFieldRow([
          ("Avg Reps Per Set", stats.avgRepsPerSet),
          ("Avg Duration", stats.avgTrainingDuration),
        ]),
        _getContentFieldRow([
          ("Avg Volume", stats.avgVolume),
          ("Max Volume", stats.maxVolume),
        ]),
        _getContentFieldRow([
          ("Avg Weight", stats.avgWeight),
          ("Max Weight", stats.maxWeight),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }
}
