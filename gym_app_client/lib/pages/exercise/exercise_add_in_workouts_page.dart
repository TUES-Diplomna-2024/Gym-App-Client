import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';
import 'package:gym_app_client/utils/components/buttons/exercise/exercise_add_in_workout_done_button.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';
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
  final _workoutService = WorkoutService();

  late final List<WorkoutPreviewModel> _userWorkouts;
  bool _isLoading = true;
  List<String> selectedWorkoutIds = [];

  @override
  void initState() {
    _getUserWorkouts();
    super.initState();
  }

  Future<void> _getUserWorkouts() async {
    final serviceResult = await _workoutService.getCurrUserWorkoutPreviews();

    if (serviceResult.popUpInfo != null) {
      final popup = InformativePopUp(info: serviceResult.popUpInfo!);

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }
    } else {
      _userWorkouts = serviceResult.data!;
      setState(() => _isLoading = false);
    }
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
              onSelect: (id) => setState(() => selectedWorkoutIds.add(id)),
              onUnselect: (id) => setState(() => selectedWorkoutIds.remove(id)),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add In Workouts",
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
      body: _getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ExerciseAddInWorkoutDoneButton(
        exerciseId: widget.exerciseId,
        selectedWorkoutIds: selectedWorkoutIds,
      ),
    );
  }
}
