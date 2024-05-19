import 'dart:convert';
import 'package:http/http.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class ExerciseRecordViewModel {
  late final String id;
  late final String onCreated;
  late final int sets;
  late final int reps;
  late final double weight;
  late final Duration duration;

  ExerciseRecordViewModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"];
    onCreated = normalizeDateString(data["onCreated"]);
    sets = data["sets"];
    reps = data["reps"];
    duration = Duration(seconds: data["duration"]);
    weight = normalizeDouble(data["weight"]);
  }

  static List<ExerciseRecordViewModel> getRecordViewsFromResponse(
      Response response) {
    List<dynamic> body = json.decode(response.body);

    return List<ExerciseRecordViewModel>.from(
      body.map((r) => ExerciseRecordViewModel.loadFromMap(r)),
    );
  }
}
