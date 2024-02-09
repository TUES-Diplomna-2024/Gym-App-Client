import 'package:flutter/material.dart';

class WorkoutPreview extends StatelessWidget {
  final String workoutId;
  final String workoutName;
  final int workoutExerciseCount;

  const WorkoutPreview({
    super.key,
    required this.workoutId,
    required this.workoutName,
    required this.workoutExerciseCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(left: 25, right: 25, top: 15),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                workoutName,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 30),
            Text(
              "Exercises: $workoutExerciseCount",
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
      onTap: () => debugPrint("ID: $workoutId"),
    );
  }
}
