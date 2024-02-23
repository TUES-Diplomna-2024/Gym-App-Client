import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';
import 'package:gym_app_client/utils/components/buttons/exercise/exercise_add_in_workouts_done_button.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';
import 'package:gym_app_client/utils/components/previews/selectable_workout_preview.dart';

class ExerciseAddInWorkoutsPage extends StatefulWidget {
  final String exerciseId;

  const ExerciseAddInWorkoutsPage({
    super.key,
    required this.exerciseId,
  });

  @override
  State<ExerciseAddInWorkoutsPage> createState() =>
      _ExerciseAddInWorkoutsPageState();
}

class _ExerciseAddInWorkoutsPageState extends State<ExerciseAddInWorkoutsPage> {
  final _userService = UserService();
  final _workoutService = WorkoutService();

  late final List<WorkoutPreviewModel> _userWorkouts;
  bool _isLoading = true;
  List<String> selectedWorkoutIds = [];

  @override
  void initState() {
    _workoutService.getCurrUserWorkoutPreviews().then(
      (serviceResult) {
        if (serviceResult.isSuccessful) {
          _userWorkouts = serviceResult.data!;
          if (mounted) setState(() => _isLoading = false);
        } else {
          serviceResult.showPopUp(context);
          if (serviceResult.shouldSignOutUser) _userService.signOut(context);
        }
      },
    );

    super.initState();
  }

  Widget _getBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_userWorkouts.isEmpty) {
      return const Center(
        child: Text(
          "You don't have any workouts!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 18),
      child: ListView.builder(
        itemCount: _userWorkouts.length,
        itemBuilder: (_, int index) {
          return SelectableWorkoutPreview(
            workout: _userWorkouts[index],
            onSelect: (id) {
              if (mounted) setState(() => selectedWorkoutIds.add(id));
            },
            onUnselect: (id) {
              if (mounted) setState(() => selectedWorkoutIds.remove(id));
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackLeadingAppBar(title: "Add In Workouts", context: context),
      body: _getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ExerciseAddInWorkoutsDoneButton(
        exerciseId: widget.exerciseId,
        selectedWorkoutIds: selectedWorkoutIds,
      ),
    );
  }
}
