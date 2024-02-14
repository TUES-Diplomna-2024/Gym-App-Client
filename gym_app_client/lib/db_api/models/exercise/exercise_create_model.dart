class ExerciseCreateModel {
  final String name;
  final String type;
  final String difficulty;
  final String muscleGroups;
  final String instructions;
  final String? equipment;
  final bool isPrivate;

  ExerciseCreateModel({
    required this.name,
    required this.type,
    required this.difficulty,
    required this.muscleGroups,
    required this.instructions,
    required this.equipment,
    required this.isPrivate,
  });

  Map<String, String> toMap() {
    var map = <String, String>{
      "name": name,
      "type": type,
      "difficulty": difficulty,
      "muscleGroups": muscleGroups,
      "instructions": instructions,
      "isPrivate": isPrivate.toString(),
    };

    if (equipment != null) map["equipment"] = equipment!;

    return map;
  }
}
