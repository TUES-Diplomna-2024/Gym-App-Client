import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_visibility_form_field.dart';
import 'package:gym_app_client/utils/components/views/previews/exercise_preview.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';

class AdminPanelExercisesPage extends StatefulWidget {
  const AdminPanelExercisesPage({super.key});

  @override
  State<AdminPanelExercisesPage> createState() =>
      _AdminPanelExercisesPageState();
}

class _AdminPanelExercisesPageState extends State<AdminPanelExercisesPage> {
  final _userService = UserService();
  final _exerciseService = ExerciseService();
  final _searchController = TextEditingController();

  ExerciseVisibility? _selectedVisibility;
  List<ExercisePreviewModel>? _searchResults;

  void _getExerciseSearchResults() {
    final search = _searchController.text.trim();

    if (search.isEmpty && mounted) {
      setState(() => _searchController.text = "");
      return;
    }

    if (_selectedVisibility != null) {
      _exerciseService
          .getExerciseSearchResultsAdvanced(search, _selectedVisibility!)
          .then(
        (serviceResult) {
          if (serviceResult.isSuccessful && mounted) {
            setState(() => _searchResults = serviceResult.data!);
          } else {
            serviceResult.showPopUp(context);
            if (serviceResult.shouldSignOutUser) _userService.signOut(context);
          }
        },
      );
    }
  }

  Widget _getSearchResultsBody() {
    if (_searchResults == null ||
        _searchController.text.isEmpty ||
        _selectedVisibility == null) {
      return const SizedBox();
    }

    if (_searchResults!.isEmpty) {
      return const Center(
        child: Text(
          "No results!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 23),
      child: ListView.builder(
        itemCount: _searchResults!.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            child: ExercisePreview(exercise: _searchResults![index]),
            onTap: () {
              if (mounted) {
                Navigator.of(context).pushNamed("/exercise", arguments: [
                  _searchResults![index].id,
                  _getExerciseSearchResults
                ]);
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
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 23),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              onChanged: (_) => _getExerciseSearchResults(),
              leading: const Icon(Icons.search),
              trailing: [
                IconButton(
                  onPressed: () {
                    if (mounted) setState(() => _searchController.text = "");
                  },
                  icon: const Icon(Icons.clear_outlined),
                ),
              ],
            ),
            const SizedBox(height: 23),
            ExerciseVisibilityFormField(
              onVisibilityChanged: (ExerciseVisibility? value) {
                if (mounted) {
                  setState(() => _selectedVisibility = value!);
                }
                _getExerciseSearchResults();
              },
              padding: const EdgeInsets.all(0),
            ),
            Expanded(
              child: _getSearchResultsBody(),
            ),
          ],
        ),
      ),
    );
  }
}
