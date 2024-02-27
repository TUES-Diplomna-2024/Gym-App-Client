import 'dart:convert';
import 'package:http/http.dart';
import 'package:gym_app_client/utils/common/statistic_data_point.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class ExerciseStatsModel {
  late final int totalSets;
  late final int totalReps;
  late final double avgRepsPerSet;
  late final double avgTrainingDuration;
  late final double avgVolume;
  late final double avgWeight;
  late final double maxVolume;
  late final double maxWeight;
  late final List<StatisticDataPoint> dataPoints;

  ExerciseStatsModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    totalSets = body["totalSets"];
    totalReps = body["totalReps"];

    avgRepsPerSet = normalizeDouble(body["avgRepsPerSet"]);
    avgTrainingDuration = normalizeDouble(body["avgTrainingDuration"]);
    avgVolume = normalizeDouble(body["avgVolume"]);
    avgWeight = normalizeDouble(body["avgWeight"]);
    maxVolume = normalizeDouble(body["maxVolume"]);
    maxWeight = normalizeDouble(body["maxWeight"]);

    dataPoints = StatisticDataPoint.getDataPointsFromBody(body["dataPoints"]);
  }
}
