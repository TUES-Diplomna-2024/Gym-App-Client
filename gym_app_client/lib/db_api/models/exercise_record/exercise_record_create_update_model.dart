import 'dart:convert';

class ExerciseRecordCreateUpdateModel {
  final int sets;
  final int reps;
  final int duration;
  final double? weight;

  ExerciseRecordCreateUpdateModel({
    required this.sets,
    required this.reps,
    required this.duration,
    this.weight,
  });

  String toJson() => jsonEncode({
        "sets": sets,
        "reps": reps,
        "weight": weight,
        "duration": duration,
      });
}
