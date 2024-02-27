import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';
import 'package:gym_app_client/utils/components/buttons/workout/workout_actions_popup_menu_button.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/views/previews/exercise_preview.dart';

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
  final _userService = UserService();
  final _workoutService = WorkoutService();
  late WorkoutViewModel _workoutView;
  bool _isLoading = true;

  @override
  void initState() {
    _workoutService.getWorkoutById(widget.workoutId).then(
      (serviceResult) {
        if (serviceResult.isSuccessful) {
          _workoutView = serviceResult.data!;
          if (mounted) setState(() => _isLoading = false);
        } else {
          serviceResult.showPopUp(context);
          if (serviceResult.shouldSignOutUser) _userService.signOut(context);
        }
      },
    );

    super.initState();
  }

  Widget _getExercisePreviews() {
    if (_workoutView.exerciseCount == 0) {
      return const Center(
        child: Column(
          children: [
            SizedBox(height: 180),
            Text(
              "You don't have any exercises added in this workout!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackLeadingAppBar(title: "Workout", context: context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 23),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _workoutView.name,
                              style: const TextStyle(fontSize: 26),
                            ),
                          ),
                          const SizedBox(width: 16),
                          WorkoutActionsPopupMenuButton(
                            workoutCurrState: _workoutView,
                            onWorkoutUpdated: (name, description, exercises) {
                              if (mounted) {
                                setState(
                                  () => _workoutView.updateView(
                                      name, description, exercises),
                                );
                              }
                            },
                          ),
                        ],
                      ),
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
