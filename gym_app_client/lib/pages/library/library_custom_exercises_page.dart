import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/views/previews/exercise_preview.dart';

class LibraryCustomExercisesPage extends StatefulWidget {
  const LibraryCustomExercisesPage({super.key});

  @override
  State<LibraryCustomExercisesPage> createState() =>
      _LibraryCustomExercisesPageState();
}

class _LibraryCustomExercisesPageState
    extends State<LibraryCustomExercisesPage> {
  final _userService = UserService();
  final _exerciseService = ExerciseService();
  late List<ExercisePreviewModel> _userCustomExercises;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  void _loadPage() {
    _exerciseService.getCurrUserCustomExercisePreviews().then(
      (serviceResult) {
        if (serviceResult.isSuccessful) {
          _userCustomExercises = serviceResult.data!;
          if (mounted) setState(() => _isLoading = false);
        } else {
          serviceResult.showPopUp(context);
          if (serviceResult.shouldSignOutUser) _userService.signOut(context);
        }
      },
    );
  }

  Widget _getBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_userCustomExercises.isEmpty) {
      return const Center(
        child: Text(
          "You don't have any custom exercises!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 18),
      child: ListView.builder(
        itemCount: _userCustomExercises.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            child: ExercisePreview(exercise: _userCustomExercises[index]),
            onTap: () {
              if (mounted) {
                Navigator.of(context).pushNamed(
                  "/exercise",
                  arguments: [_userCustomExercises[index].id, _loadPage],
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
          if (mounted) {
            Navigator.of(context).pushNamed(
              "/exercise-create",
              arguments: _loadPage,
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
