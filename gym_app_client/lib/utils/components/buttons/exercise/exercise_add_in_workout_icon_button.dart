import 'package:flutter/material.dart';

class ExerciseAddInWorkoutIconButton extends IconButton {
  ExerciseAddInWorkoutIconButton({
    super.key,
    required BuildContext context,
    required String exerciseId,
  }) : super(
          icon: const Icon(Icons.add_circle_outline),
          iconSize: 26,
          onPressed: () {
            if (context.mounted) {
              Navigator.of(context).pushNamed(
                "/exercise-add-in-workouts",
                arguments: exerciseId,
              );
            }
          },
        );
}
