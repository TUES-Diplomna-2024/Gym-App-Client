import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/utils/components/common/custom_app_bar.dart';
import 'package:gym_app_client/utils/components/common/informative_popup.dart';
import 'package:gym_app_client/utils/components/previews/exercise_preview.dart';

class ExerciseSearchPage extends StatefulWidget {
  const ExerciseSearchPage({super.key});

  @override
  State<ExerciseSearchPage> createState() => _ExerciseSearchPageState();
}

class _ExerciseSearchPageState extends State<ExerciseSearchPage> {
  final _exerciseService = ExerciseService();
  final _searchController = TextEditingController();

  List<ExercisePreviewModel>? _searchResults;

  Future<void> _getExerciseSearchResults() async {
    final search = _searchController.text.trim();

    if (search.isEmpty) {
      if (mounted) setState(() => _searchController.text = "");
      return;
    }

    final serviceResult =
        await _exerciseService.getExerciseSearchResults(search);

    if (serviceResult.popUpInfo != null) {
      final popup = InformativePopUp(info: serviceResult.popUpInfo!);

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }
    } else {
      if (mounted) setState(() => _searchResults = serviceResult.data!);
    }
  }

  Widget _getSearchResultsBody() {
    if (_searchResults == null || _searchController.text.isEmpty) {
      return const SizedBox();
    }

    if (_searchResults!.isEmpty) {
      return const Center(
        child: Text(
          "No results!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                  Navigator.of(context).pushNamed(
                    "/exercise",
                    arguments: _searchResults![index].id,
                  );
                }
              },
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Search"),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 23),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              onChanged: (_) async => await _getExerciseSearchResults(),
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
            Expanded(
              child: _getSearchResultsBody(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
