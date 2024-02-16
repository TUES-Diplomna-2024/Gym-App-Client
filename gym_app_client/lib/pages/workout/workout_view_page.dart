import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';
import 'package:gym_app_client/utils/components/previews/exercise_preview.dart';

class WorkoutViewPage extends StatefulWidget {
  final String workoutId;

  const WorkoutViewPage({
    super.key,
    required this.workoutId,
  });

  @override
  State<WorkoutViewPage> createState() => _WorkoutViewPageState();
}

class _WorkoutViewPageState extends State<WorkoutViewPage> {
  final _workoutService = WorkoutService();
  late WorkoutViewModel _workoutView;
  bool _isLoading = true;

  @override
  void initState() {
    _getWorkoutView();
    super.initState();
  }

  Future<void> _getWorkoutView() async {
    final serviceResult =
        await _workoutService.getWorkoutById(widget.workoutId);

    if (serviceResult.popUpInfo != null) {
      final popup = InformativePopUp(info: serviceResult.popUpInfo!);

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }
    } else {
      _workoutView = serviceResult.data!;
      setState(() => _isLoading = false);
    }
  }

  Widget _getExercisePreviews() {
    if (_workoutView.exerciseCount == 0) {
      return const Center(
        child: Text(
          "You don't have any exercises added in this workout!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      );
    }

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _workoutView.exerciseCount,
        itemBuilder: (_, int index) {
          return GestureDetector(
            child: ExercisePreview(exercise: _workoutView.exercises![index]),
            onTap: () {
              if (mounted) {
                Navigator.of(context).pushNamed(
                  "/exercise",
                  arguments: _workoutView.exercises![index].id,
                );
              }
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Workout",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 23),
                      Text(
                        _workoutView.name,
                        style: const TextStyle(fontSize: 26),
                      ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       onPressed: () => debugPrint("Add +"),
                      //       icon: const Icon(Icons.add_box_rounded),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 15),
                      ContentField(
                        fieldIcon: Icons.description_outlined,
                        fieldName: "Description",
                        fieldValue: _workoutView.description ?? "None",
                        padding: const EdgeInsets.only(bottom: 15),
                        isMultiline: true,
                      ),
                      ContentField(
                        fieldIcon: Icons.directions_run,
                        fieldName: "Exercises",
                        fieldValue: _workoutView.exerciseCount,
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      _getExercisePreviews(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
