import 'dart:convert';
import 'dart:ffi';

class ExerciseRecordCreateUpdateModel {
  final UnsignedInt sets;
  final UnsignedInt reps;
  final UnsignedInt duration;
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
