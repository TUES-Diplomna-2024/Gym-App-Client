import 'dart:convert';
import 'package:http/http.dart';

class ExerciseViewModel {
  late final String id;
  late final String name;
  late final String type;
  late final String difficulty;
  late final String muscleGroups;
  late final String instructions;
  late final String? equipment;
  late final bool isPrivate;

  ExerciseViewModel.loadFromResponse(Response response) {
    Map<String, dynamic> body = json.decode(response.body);

    id = body["id"];
    name = body["name"];
    type = body["type"];
    difficulty = body["difficulty"];
    muscleGroups = body["muscleGroups"];
    instructions = body["instructions"];
    equipment = body["equipment"];
    isPrivate = body["isPrivate"];
  }
}
