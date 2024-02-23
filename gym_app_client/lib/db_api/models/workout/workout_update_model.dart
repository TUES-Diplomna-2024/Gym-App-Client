import 'dart:convert';

class WorkoutUpdateModel {
  final String name;
  final String? description;
  final List<String>? exercisesIds;

  WorkoutUpdateModel({
    required this.name,
    required this.description,
    required this.exercisesIds,
  });

  String toJson() => jsonEncode({
        "name": name,
        "description": description,
        "exercises": exercisesIds,
      });
}
