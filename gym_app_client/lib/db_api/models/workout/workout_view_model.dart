import 'dart:convert';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:http/http.dart';

class WorkoutViewModel {
  late final String id;

  late String name;
  String? description;
  List<ExercisePreviewModel>? exercises;
  late int exerciseCount;

  WorkoutViewModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    id = body["id"];
    name = body["name"];
    description = body["description"];

    if (body["exercises"] != null) {
      exercises =
          ExercisePreviewModel.getExercisePreviewsFromBody(body["exercises"]);
      exerciseCount = exercises!.length;
    } else {
      exerciseCount = 0;
    }
  }

  void updateView(
    String name,
    String? description,
    List<ExercisePreviewModel>? exercises,
  ) {
    this.name = name;
    this.description = description;
    this.exercises = exercises;
    exerciseCount = exercises?.length ?? 0;
  }
}
