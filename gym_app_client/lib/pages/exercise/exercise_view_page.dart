import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/utils/components/buttons/exercise/exercise_actions_popup_menu_button.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/informative_popup.dart';
import 'package:gym_app_client/utils/constants/role_constants.dart';

class ExerciseViewPage extends StatefulWidget {
  final String exerciseId;

  const ExerciseViewPage({
    super.key,
    required this.exerciseId,
  });

  @override
  State<ExerciseViewPage> createState() => _ExerciseViewPageState();
}

class _ExerciseViewPageState extends State<ExerciseViewPage> {
  final _exerciseService = ExerciseService();
  final _tokenService = TokenService();

  late ExerciseViewModel _exerciseView;
  late final bool _areEditAndDeleteAllowed;
  bool _isLoading = true;

  @override
  void initState() {
    _getExerciseView();
    super.initState();
  }

  Future<void> _getExerciseView() async {
    final serviceResult =
        await _exerciseService.getExerciseById(widget.exerciseId);

    if (serviceResult.popUpInfo != null) {
      final popup = InformativePopUp(info: serviceResult.popUpInfo!);

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(popup);
      }
    } else {
      _exerciseView = serviceResult.data!;

      final currUserRole = await _tokenService.getCurrUserRole();

      if (_exerciseView.isPrivate == false &&
          !RoleConstants.adminRoles.contains(currUserRole)) {
        _areEditAndDeleteAllowed = false;
      } else {
        _areEditAndDeleteAllowed = true;
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Exercise",
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _exerciseView.name,
                              style: const TextStyle(fontSize: 26),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ExerciseActionsPopupMenuButton(
                            context: context,
                            areEditAndDeleteAllowed: _areEditAndDeleteAllowed,
                            exerciseCurrState: _exerciseView,
                            onExerciseUpdated: (updateModel) {
                              if (mounted) {
                                setState(() =>
                                    _exerciseView.updateView(updateModel));
                              }
                            },
                          ),
                          Icon(
                            _exerciseView.isPrivate
                                ? Icons.lock_outlined
                                : Icons.public_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ContentField(
                        fieldIcon: Icons.bolt_outlined,
                        fieldName: "Difficulty",
                        fieldValue: _exerciseView.difficulty,
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      ContentField(
                        fieldIcon: Icons.sports_gymnastics_outlined,
                        fieldName: "Type",
                        fieldValue: _exerciseView.type,
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      ContentField(
                        fieldIcon: Icons.directions_run,
                        fieldName: "Muscle Groups",
                        fieldValue: _exerciseView.muscleGroups,
                        padding: const EdgeInsets.only(bottom: 15),
                        isMultiline: true,
                      ),
                      ContentField(
                        fieldIcon: Icons.fitness_center_outlined,
                        fieldName: "Equipment",
                        fieldValue: _exerciseView.equipment ?? "None",
                        padding: const EdgeInsets.only(bottom: 15),
                        isMultiline: true,
                      ),
                      ContentField(
                        fieldIcon: Icons.sports,
                        fieldName: "Instructions",
                        fieldValue: _exerciseView.instructions,
                        padding: const EdgeInsets.only(bottom: 15),
                        isMultiline: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
