import 'dart:io';

import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';

class ExerciseUpdateModel {
  final String name;
  final String instructions;
  final String muscleGroups;
  final ExerciseType type;
  final ExerciseDifficulty difficulty;
  final String? equipment;
  final List<String>? imagesToBeRemoved;
  final List<File>? imagesToBeAdded;

  ExerciseUpdateModel({
    required this.name,
    required this.instructions,
    required this.muscleGroups,
    required this.type,
    required this.difficulty,
    this.equipment,
    this.imagesToBeRemoved,
    this.imagesToBeAdded,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": name,
      "instructions": instructions,
      "muscleGroups": muscleGroups,
      "type": type.name,
      "difficulty": difficulty.name,
      "imagesToBeRemoved": imagesToBeRemoved,
      "imagesToBeAdded": imagesToBeAdded,
    };

    if (equipment != null && equipment!.isNotEmpty) {
      map["equipment"] = equipment!;
    }

    return map;
  }
}
