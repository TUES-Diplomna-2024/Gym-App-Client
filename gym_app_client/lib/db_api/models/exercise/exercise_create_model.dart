import 'dart:io';

import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';

class ExerciseCreateModel {
  final String name;
  final String instructions;
  final String muscleGroups;
  final ExerciseType type;
  final ExerciseDifficulty difficulty;
  final String? equipment;
  final ExerciseVisibility visibility;
  final List<File>? images;

  ExerciseCreateModel({
    required this.name,
    required this.instructions,
    required this.muscleGroups,
    required this.type,
    required this.difficulty,
    required this.visibility,
    this.equipment,
    this.images,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": name,
      "instructions": instructions,
      "muscleGroups": muscleGroups,
      "type": type.name,
      "difficulty": difficulty.name,
      "visibility": visibility.name,
      "images": images,
    };

    if (equipment != null && equipment!.isNotEmpty) {
      map["equipment"] = equipment!;
    }

    return map;
  }
}
