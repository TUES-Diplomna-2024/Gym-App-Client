import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_view_model.dart';
import 'package:gym_app_client/utils/components/fields/content/preview_field.dart';

class ExerciseRecordView extends StatelessWidget {
  final ExerciseRecordViewModel record;

  const ExerciseRecordView({
    super.key,
    required this.record,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds';
  }

  String _getRecordDataString() {
    String setStr = "${record.sets} set${record.sets > 1 ? 's' : ''}";
    String repStr = "${record.reps} rep${record.reps > 1 ? 's' : ''}";
    String weightStr = "${record.weight} kg";
    return "$setStr x $repStr x $weightStr";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 23),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    record.onCreated,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.timer_outlined),
                      const SizedBox(width: 10),
                      Text(
                        _formatDuration(record.duration),
                        style: const TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PreviewField(
            fieldValue: _getRecordDataString(),
            padding: const EdgeInsets.only(bottom: 15),
          ),
        ],
      ),
    );
  }
}
