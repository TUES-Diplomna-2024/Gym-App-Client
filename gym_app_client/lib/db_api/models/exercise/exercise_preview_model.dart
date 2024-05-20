import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';
import 'package:http/http.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class ExercisePreviewModel {
  late final String id;
  late final String name;
  late final String type;
  late final String muscleGroups;
  late final Color difficultyColor;
  late final Icon visibilityIcon;

  ExercisePreviewModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    type = capitalizeFirstLetter(ExerciseType.values[data["type"]].name);
    muscleGroups = data["muscleGroups"];
    difficultyColor = _getDifficultyColor(data["difficulty"]);
    visibilityIcon = _getVisivilityIcon(data["visibility"]);
  }

  Color _getDifficultyColor(int index) {
    switch (ExerciseDifficulty.values[index]) {
      case ExerciseDifficulty.beginner:
        return ExerciseConstants.beginnerDifficultyColor;
      case ExerciseDifficulty.intermediate:
        return ExerciseConstants.intermediateDifficultyColor;
      case ExerciseDifficulty.expert:
        return ExerciseConstants.expertDifficultyColor;
    }
  }

  Icon _getVisivilityIcon(int index) {
    switch (ExerciseVisibility.values[index]) {
      case ExerciseVisibility.public:
        return const Icon(Icons.public_outlined);
      case ExerciseVisibility.private:
        return const Icon(Icons.lock_outlined);
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
