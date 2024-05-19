import 'dart:convert';

class WorkoutCreateModel {
  final String name;
  final String? description;

  WorkoutCreateModel({
    required this.name,
    this.description,
  });

  String toJson() => jsonEncode({
        "name": name,
        "description": description,
      });
}
