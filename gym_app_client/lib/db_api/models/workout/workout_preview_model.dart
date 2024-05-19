import 'dart:convert';
import 'package:http/http.dart';

class WorkoutPreviewModel {
  late final String id;
  late final String name;
  late final int exerciseCount;

  WorkoutPreviewModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    exerciseCount = data["exerciseCount"];
  }

  static List<WorkoutPreviewModel> getWorkoutPreviewsFromResponse(
      Response response) {
    List<dynamic> body = json.decode(response.body);

    return List<WorkoutPreviewModel>.from(
      body.map((e) => WorkoutPreviewModel.loadFromMap(e)),
    );
  }
}
