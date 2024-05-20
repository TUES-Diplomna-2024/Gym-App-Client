import 'dart:convert';
import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';
import 'package:http/http.dart';

class ExerciseViewModel {
  late final String id;
  late final ExerciseVisibility visibility;
  late final String name;
  late final String instructions;
  late final String muscleGroups;
  late final String? equipment;
  late final ExerciseType type;
  late final ExerciseDifficulty difficulty;
  late final bool isCustom;
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
    isCustom = body["isCustom"];
  }
}
