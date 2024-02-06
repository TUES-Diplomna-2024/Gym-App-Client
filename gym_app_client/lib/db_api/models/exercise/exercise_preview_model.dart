import 'dart:convert';
import 'package:http/http.dart';

class ExercisePreviewModel {
  late final String id;
  late final String name;
  late final String type;
  late final String difficulty;
  late final String muscleGroups;
  late final bool isPrivate;

  ExercisePreviewModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    type = (data["type"] as String).replaceAll("_", " ");
    difficulty = data["difficulty"];
    muscleGroups = data["muscleGroups"];
    isPrivate = data["isPrivate"];
  }

  static List<ExercisePreviewModel> getExercisePreviewsFromResponse(
      Response response) {
    List<dynamic> body = json.decode(response.body);

    return List<ExercisePreviewModel>.from(
        body.map((e) => ExercisePreviewModel.loadFromMap(e)));
  }
}
