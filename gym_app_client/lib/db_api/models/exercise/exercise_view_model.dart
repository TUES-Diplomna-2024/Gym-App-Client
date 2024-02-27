import 'dart:convert';
import 'package:http/http.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

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
    type = capitalizeFirstLetter(body["type"]);
    difficulty = capitalizeFirstLetter(body["difficulty"]);
    muscleGroups = body["muscleGroups"];
    instructions = body["instructions"];
    equipment = body["equipment"];
    isPrivate = body["isPrivate"];
    ownerId = body["ownerId"];
    ownerUsername = body["ownerUsername"];
  }

  void updateView(ExerciseUpdateModel updateModel) {
    name = updateModel.name;
    type = updateModel.type;
    difficulty = updateModel.difficulty;
    muscleGroups = updateModel.muscleGroups;
    instructions = updateModel.instructions;
    equipment = updateModel.equipment;
  }
}
