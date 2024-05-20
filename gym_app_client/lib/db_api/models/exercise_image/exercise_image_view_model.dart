import 'package:flutter/material.dart';

class ExerciseImageViewModel {
  late final String id;
  late final Image image;

  ExerciseImageViewModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"];
    image = Image.network(data["uri"]);
  }

  static List<ExerciseImageViewModel> getExercisePreviewsFromBody(
      List<dynamic> body) {
    return List<ExerciseImageViewModel>.from(
        body.map((e) => ExerciseImageViewModel.loadFromMap(e)));
  }
}
