import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/utils/components/previews/workout_preview.dart';

class SelectableWorkoutPreview extends StatefulWidget {
  final WorkoutPreviewModel workout;
  final void Function(String id) onSelect;
  final void Function(String id) onUnselect;

  const SelectableWorkoutPreview({
    super.key,
    required this.workout,
    required this.onSelect,
    required this.onUnselect,
  });

  @override
  State<SelectableWorkoutPreview> createState() =>
      _SelectableWorkoutPreviewState();
}

class _SelectableWorkoutPreviewState extends State<SelectableWorkoutPreview> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            isSelected
                ? Icons.check_box
                : Icons.check_box_outline_blank_outlined,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: WorkoutPreview(workout: widget.workout),
          ),
        ],
      ),
      onTap: () => setState(() {
        isSelected = !isSelected;

        if (isSelected) {
          widget.onSelect(widget.workout.id);
        } else {
          widget.onUnselect(widget.workout.id);
        }
      }),
    );
  }
}
