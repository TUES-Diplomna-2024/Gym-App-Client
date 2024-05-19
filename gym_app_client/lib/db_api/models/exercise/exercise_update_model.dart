import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';

class ExerciseUpdateModel {
  final String name;
  final String instructions;
  final String muscleGroups;
  final ExerciseType type;
  final ExerciseDifficulty difficulty;
  final String? equipment;
  // TODO: Add image handling

  ExerciseUpdateModel({
    required this.name,
    required this.instructions,
    required this.muscleGroups,
    required this.type,
    required this.difficulty,
    this.equipment,
  });

  Map<String, String> toMap() {
    var map = <String, String>{
      "name": name,
      "instructions": instructions,
      "muscleGroups": muscleGroups,
      "type": type.name,
      "difficulty": difficulty.name
    };

    if (equipment != null && equipment!.isNotEmpty) {
      map["equipment"] = equipment!;
    }

    return map;
  }
}
