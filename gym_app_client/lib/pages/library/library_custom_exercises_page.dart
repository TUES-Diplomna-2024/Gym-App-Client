import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';
import 'package:gym_app_client/utils/components/previews/exercise_preview.dart';

class LibraryCustomExercisesPage extends StatefulWidget {
  const LibraryCustomExercisesPage({super.key});

  @override
  State<LibraryCustomExercisesPage> createState() =>
      _LibraryCustomExercisesPageState();
}

class _LibraryCustomExercisesPageState
    extends State<LibraryCustomExercisesPage> {
  final _userService = UserService();
  late final List<ExercisePreviewModel> _userCustomExercises;
  bool _isLoading = true;

  @override
  void initState() {
    _getUserCustomExercises();
    super.initState();
  }

  Future<void> _getUserCustomExercises() async {
    final serviceResult =
        await _userService.getCurrUserCustomExercisePreviews();

    if (serviceResult.popUpInfo != null) {
      final popup = InformativePopUp(info: serviceResult.popUpInfo!);

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }
    } else {
      _userCustomExercises = serviceResult.data!;
      setState(() => _isLoading = false);
    }
  }

  Widget _getBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_userCustomExercises.isEmpty) {
      return const Center(
        child: Text(
          "You don't have any custom exercises!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
              onTap: () => Navigator.of(context).pushNamed("/exercise",
                  arguments: _userCustomExercises[index].id),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/exercise-create"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
