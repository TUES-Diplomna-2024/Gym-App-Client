import 'dart:convert';
import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';
import 'package:http/http.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';

class ExerciseViewModel {
  late final String id;
  late final ExerciseVisibility visibility;
  late String name;
  late String instructions;
  late String muscleGroups;
  String? equipment;
  late ExerciseType type;
  late ExerciseDifficulty difficulty;
  // TODO: Add image handling

  ExerciseViewModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    id = body["id"];
    visibility = ExerciseVisibility.values[body["visibility"]];

    name = body["name"];
    instructions = body["instructions"];
    muscleGroups = body["muscleGroups"];
    equipment = body["equipment"];

    type = ExerciseType.values[body["type"]];
    difficulty = ExerciseDifficulty.values[body["difficulty"]];
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
