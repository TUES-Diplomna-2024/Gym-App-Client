import 'dart:convert';

class ExerciseRecordCreateUpdateModel {
  final int sets;
  final int reps;
  final double? weight;
  final int duration;

  ExerciseRecordCreateUpdateModel({
    required this.sets,
    required this.reps,
    this.weight,
    required this.duration,
  });

  String toJson() => jsonEncode({
        "sets": sets,
        "reps": reps,
        "weight": weight,
        "duration": duration,
      });
}
