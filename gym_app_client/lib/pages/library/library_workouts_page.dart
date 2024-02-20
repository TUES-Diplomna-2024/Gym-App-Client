import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/db_api/services/workout_service.dart';
import 'package:gym_app_client/utils/components/previews/workout_preview.dart';

class LibraryWorkoutsPage extends StatefulWidget {
  const LibraryWorkoutsPage({super.key});

  @override
  State<LibraryWorkoutsPage> createState() => _LibraryWorkoutsPageState();
}

class _LibraryWorkoutsPageState extends State<LibraryWorkoutsPage> {
  final _userService = UserService();
  final _workoutService = WorkoutService();
  late final List<WorkoutPreviewModel> _userWorkouts;
  bool _isLoading = true;

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
          return GestureDetector(
            child: WorkoutPreview(workout: _userWorkouts[index]),
            onTap: () {
              if (mounted) {
                Navigator.of(context).pushNamed(
                  "/workout",
                  arguments: _userWorkouts[index].id,
                );
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("+ action button clicked!");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
