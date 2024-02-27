import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class ExercisePreviewModel {
  late final String id;
  late final String name;
  late final String type;
  late final Color difficulty;
  late final String muscleGroups;
  late final bool isPrivate;

  ExercisePreviewModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    type = capitalizeFirstLetter(data["type"]);
    difficulty = _getDifficultyColor(data["difficulty"]);
    muscleGroups = data["muscleGroups"];
    isPrivate = data["isPrivate"];
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case "beginner":
        return ExerciseConstants.beginnerDifficultyColor;
      case "intermediate":
        return ExerciseConstants.intermediateDifficultyColor;
      case "expert":
        return ExerciseConstants.expertDifficultyColor;
      default:
        return ExerciseConstants.unknownDifficultyColor;
    }
  }

  static List<ExercisePreviewModel> getExercisePreviewsFromResponse(
      Response response) {
    List<dynamic> body = json.decode(response.body);

    return getExercisePreviewsFromBody(body);
  }

  static List<ExercisePreviewModel> getExercisePreviewsFromBody(
      List<dynamic> body) {
    return List<ExercisePreviewModel>.from(
        body.map((e) => ExercisePreviewModel.loadFromMap(e)));
  }
}
