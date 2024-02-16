import 'dart:convert';

class ExerciseUpdateModel {
  late final String name;
  late final String instructions;
  late final String muscleGroups;
  late final String type;
  late final String difficulty;
  late final String? equipment;

  ExerciseUpdateModel({
    required this.name,
    required this.instructions,
    required this.muscleGroups,
    required this.type,
    required this.difficulty,
    this.equipment,
  });

  String toJson() => jsonEncode({
        "name": name,
        "instructions": instructions,
        "muscleGroups": muscleGroups,
        "type": type,
        "difficulty": difficulty,
        "equipment": equipment,
      });
}
