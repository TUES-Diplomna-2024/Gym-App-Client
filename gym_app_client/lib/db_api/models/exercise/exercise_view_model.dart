import 'dart:convert';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:http/http.dart';

class ExerciseViewModel {
  late final String id;
  late final bool isPrivate;
  late final String? ownerId;
  late final String? ownerUsername;

  late String name;
  late String type;
  late String difficulty;
  late String muscleGroups;
  late String instructions;
  late String? equipment;

  ExerciseViewModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    id = body["id"];
    name = body["name"];
    type = _normalizeData(body["type"]);
    difficulty = _normalizeData(body["difficulty"]);
    muscleGroups = body["muscleGroups"];
    instructions = body["instructions"];
    equipment = body["equipment"];
    isPrivate = body["isPrivate"];
    ownerId = body["ownerId"];
    ownerUsername = body["ownerUsername"];
  }

  String _normalizeData(String data) =>
      "${data[0].toUpperCase()}${data.substring(1)}";

  void updateView(ExerciseUpdateModel updateModel) {
    name = updateModel.name;
    type = updateModel.type;
    difficulty = updateModel.difficulty;
    muscleGroups = updateModel.muscleGroups;
    instructions = updateModel.instructions;
    equipment = updateModel.equipment;
  }
}
