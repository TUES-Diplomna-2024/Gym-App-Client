import 'dart:convert';

class WorkoutUpdateModel {
  final String name;
  final String? description;
  final List<String>? exercisesIds;

  WorkoutUpdateModel({
    required this.name,
    this.description,
    this.exercisesIds,
  });

  String toJson() => jsonEncode({
        "name": name,
        "description": description,
        "exercisesIds": exercisesIds,
      });
}
