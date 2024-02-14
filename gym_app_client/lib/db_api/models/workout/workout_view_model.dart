import 'dart:convert';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:http/http.dart';

class WorkoutViewModel {
  late final String id;
  late final String name;
  late final String? description;
  late final int exerciseCount;
  late final List<ExercisePreviewModel>? exercises;

  WorkoutViewModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    id = body["id"];
    name = body["name"];
    description = body["description"];
    exerciseCount = body["exerciseCount"];

    if (body["exercises"] != null) {
      exercises =
          ExercisePreviewModel.getExercisePreviewsFromBody(body["exercises"]);
    }
  }
}
