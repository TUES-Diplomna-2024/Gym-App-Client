import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/utils/components/fields/content/preview_field.dart';

class ExercisePreview extends StatelessWidget {
  final ExercisePreviewModel exercise;

  const ExercisePreview({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        gradient: LinearGradient(
          stops: const [0.03, 0.03],
          colors: [exercise.difficultyColor, Colors.blue.shade100],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
                exercise.visibilityIcon,
              ],
            ),
          ),
          PreviewField(
            fieldName: "Type",
            fieldValue: exercise.type,
            padding: const EdgeInsets.only(bottom: 15),
          ),
          PreviewField(
            fieldName: "Muscle Groups",
            fieldValue: exercise.muscleGroups,
            padding: const EdgeInsets.only(bottom: 15),
          ),
        ],
      ),
    );
  }
}
