import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/db_api/services/exercise_service.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';
import 'package:gym_app_client/utils/components/buttons/exercise/exercise_actions_popup_menu_button.dart';
import 'package:gym_app_client/utils/components/views/exercise_image_view.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/views/previews/image_preview.dart';
import 'package:gym_app_client/utils/constants/role_constants.dart';

class ExerciseInfoPage extends StatefulWidget {
  final String exerciseId;
  final void Function() onUpdate;

  const ExerciseInfoPage({
    super.key,
    required this.exerciseId,
    required this.onUpdate,
  });

  @override
  State<ExerciseInfoPage> createState() => _ExerciseInfoPageState();
}

class _ExerciseInfoPageState extends State<ExerciseInfoPage> {
  final _userService = UserService();
  final _exerciseService = ExerciseService();
  final _tokenService = TokenService();

  late ExerciseViewModel _exerciseView;
  late bool _isModifiable;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  void _loadPage() {
    _exerciseService.getExerciseById(widget.exerciseId).then(
      (serviceResult) async {
        if (serviceResult.isSuccessful) {
          _exerciseView = serviceResult.data!;

          final currUserRole = await _tokenService.getCurrUserRole();

          if (_exerciseView.visibility == ExerciseVisibility.public &&
              !RoleConstants.adminRoles.contains(currUserRole)) {
            _isModifiable = false;
          } else {
            _isModifiable = true;
          }

          if (mounted) setState(() => _isLoading = false);
        } else {
          serviceResult.showPopUp(context);
          if (serviceResult.shouldSignOutUser) _userService.signOut(context);
        }
      },
    );
  }

  Widget _previewImages() {
    return Semantics(
      child: SizedBox(
        height: 300,
        child: ListView.builder(
          key: UniqueKey(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return ImagePreview(
              image: _exerciseView.images![index].image,
              onClicked: () {
                if (mounted) {
                  showDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (_) => ExerciseImageView(
                      image: _exerciseView.images![index].image,
                    ),
                  );
                }
              },
            );
          },
          itemCount: _exerciseView.images!.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            isModifiable: _isModifiable,
                            exerciseCurrState: _exerciseView,
                            onUpdate: ({bool shouldReloadPage = true}) {
                              widget.onUpdate();
                              if (shouldReloadPage) _loadPage();
                            },
                          ),
                          Icon(
                            _exerciseView.visibility ==
                                    ExerciseVisibility.public
                                ? Icons.public_outlined
                                : Icons.lock_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ContentField(
                        fieldIcon: Icons.bolt_outlined,
                        fieldName: "Difficulty",
                        fieldValue: capitalizeFirstLetter(
                          _exerciseView.difficulty.name,
                        ),
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                      ContentField(
                        fieldIcon: Icons.sports_gymnastics_outlined,
                        fieldName: "Type",
                        fieldValue: capitalizeFirstLetter(
                          _exerciseView.type.name,
                        ),
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
                      if (_exerciseView.images != null) _previewImages(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
