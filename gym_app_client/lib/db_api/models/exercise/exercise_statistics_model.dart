import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart';
import 'package:gym_app_client/utils/common/statistic_data_point.dart';

class ExerciseStatisticsModel {
  late final UnsignedInt totalSets;
  late final UnsignedInt totalReps;
  late final double avgRepsPerSet;
  late final double avgTrainingDuration;
  late final double avgVolume;
  late final double avgWeight;
  late final double maxVolume;
  late final double maxWeight;
  late final List<StatisticDataPoint> dataPoints;

  ExerciseStatisticsModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    totalSets = body["totalSets"];
    totalReps = body["totalReps"];

    avgRepsPerSet = double.parse(body["avgRepsPerSet"].toStringAsFixed(1));
    avgTrainingDuration =
        double.parse(body["avgTrainingDuration"].toStringAsFixed(1));
    avgVolume = double.parse(body["avgVolume"].toStringAsFixed(1));
    avgWeight = double.parse(body["avgWeight"].toStringAsFixed(1));
    maxVolume = double.parse(body["maxVolume"].toStringAsFixed(1));
    maxWeight = double.parse(body["maxWeight"].toStringAsFixed(1));

    dataPoints = StatisticDataPoint.getDataPointsFromBody(body["dataPoints"]);
  }
}
