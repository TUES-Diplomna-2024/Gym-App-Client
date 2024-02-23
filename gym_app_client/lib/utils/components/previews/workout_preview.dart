import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/utils/components/fields/content/preview_field.dart';

class WorkoutPreview extends StatelessWidget {
  final WorkoutPreviewModel workout;

  const WorkoutPreview({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
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
                    workout.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
                const Icon(Icons.folder_outlined),
              ],
            ),
          ),
          PreviewField(
            fieldName: "Exercises",
            fieldValue: workout.exerciseCount,
            padding: const EdgeInsets.only(bottom: 15),
          ),
        ],
      ),
    );
  }
}
