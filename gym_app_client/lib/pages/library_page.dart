import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';
import 'package:gym_app_client/utils/components/workout_preview.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _workoutService = WorkoutService();
  late final List<WorkoutPreviewModel> _userWorkouts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserWorkouts();
  }

  Future<void> _getUserWorkouts() async {
    final serviceResult = await _workoutService.getCurrUserWorkoutPreviews();

    if (context.mounted && serviceResult.popUpInfo != null) {
      final popup = InformativePopUp(info: serviceResult.popUpInfo!);

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(popup);
    } else {
      _userWorkouts = serviceResult.data!;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Library",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _userWorkouts.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return WorkoutPreview(
                    workoutId: _userWorkouts[index].id,
                    workoutName: _userWorkouts[index].name,
                    workoutExerciseCount: _userWorkouts[index].exerciseCount,
                  );
                },
              ));
  }
}
