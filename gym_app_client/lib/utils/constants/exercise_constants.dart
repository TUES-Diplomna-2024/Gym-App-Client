import 'package:flutter/material.dart';

class ExerciseConstants {
  static const int minNameLength = 3;
  static const int maxNameLength = 70;

  static const int minInstructionsLength = 1;
  static const int maxInstructionsLength = 250;

  static const Color beginnerDifficultyColor = Colors.green;
  static const Color intermediateDifficultyColor = Colors.amber;
  static const Color expertDifficultyColor = Colors.deepPurple;
  static const Color unknownDifficultyColor = Colors.black;

  static const List<String> difficulties = [
    "Beginner",
    "Intermediate",
    "Expert"
  ];

  static const List<String> types = [
    "Cardio",
    "Weightlifting",
    "Plyometrics",
    "Powerlifting",
    "Strength",
    "Stretching",
    "Strongman",
    "Other"
  ];

  static const bool privateVisibility = true;
  static const bool publicVisibility = false;
}
