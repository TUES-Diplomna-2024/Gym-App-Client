import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/dialogs/pick_images_dialog.dart';
import 'package:gym_app_client/utils/components/views/previews/image_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';
import 'package:gym_app_client/utils/components/buttons/exercise/exercise_create_button.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_difficulty_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_type_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/multiline_text_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_visibility_form_field.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';
import 'package:gym_app_client/utils/constants/role_constants.dart';

class ExerciseCreateForm extends StatefulWidget {
  late final EdgeInsets formPadding;
  late final EdgeInsets betweenFieldsPadding;
  final void Function() onUpdate;

  ExerciseCreateForm({
    super.key,
    required EdgeInsets padding,
    required this.onUpdate,
  }) {
    formPadding = EdgeInsets.only(
      top: padding.top,
      left: padding.left,
      right: padding.right,
    );

    betweenFieldsPadding = EdgeInsets.only(bottom: padding.bottom);
  }

  @override
  State<ExerciseCreateForm> createState() => _ExerciseCreateFormState();
}

class _ExerciseCreateFormState extends State<ExerciseCreateForm> {
  final _tokenService = TokenService();
  bool _isCurrUserAdmin = false;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _muscleGroupController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _instructionsController = TextEditingController();

  ExerciseVisibility _selectedVisibility = ExerciseVisibility.private;
  ExerciseDifficulty? _selectedDifficulty;
  ExerciseType? _selectedType;

  List<XFile>? _selectedImageFiles;

  @override
  void initState() {
    _setCurrentUserAdmin();
    super.initState();
  }

  Future<void> _setCurrentUserAdmin() async {
    final currUserRole = await _tokenService.getCurrUserRole();

    if (mounted) {
      setState(() {
        _isCurrUserAdmin = RoleConstants.adminRoles.contains(currUserRole);
      });
    }
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
              image: Image.file(File(_selectedImageFiles![index].path)),
              onRemove: () {
                if (context.mounted) {
                  setState(() => _selectedImageFiles!.removeAt(index));
                }
              },
            );
          },
          itemCount: _selectedImageFiles!.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.formPadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NameFormField(
              nameController: _nameController,
              label: "Name",
              hintText: "Enter exercise name",
              prefixIcon: Icons.title_outlined,
              minLength: ExerciseConstants.minNameLength,
              maxLength: ExerciseConstants.maxNameLength,
              padding: widget.betweenFieldsPadding,
            ),
            if (_isCurrUserAdmin) ...{
              ExerciseVisibilityFormField(
                defaultVisibility: _selectedVisibility,
                onVisibilityChanged: (ExerciseVisibility? visibility) {
                  if (mounted) {
                    setState(() => _selectedVisibility = visibility!);
                  }
                },
                padding: widget.betweenFieldsPadding,
              ),
            },
            ExerciseDifficultyFormField(
              onDifficultyChanged: (ExerciseDifficulty? difficulty) {
                if (mounted) {
                  setState(() => _selectedDifficulty = difficulty!);
                }
              },
              padding: widget.betweenFieldsPadding,
            ),
            ExerciseTypeFormField(
              onTypeChanged: (ExerciseType? type) {
                if (mounted) setState(() => _selectedType = type!);
              },
              padding: widget.betweenFieldsPadding,
            ),
            MultilineTextFormField(
              controller: _muscleGroupController,
              label: "Muscle Groups",
              hintText: "Enter activated muscle groups",
              prefixIcon: Icons.directions_run,
              padding: widget.betweenFieldsPadding,
            ),
            MultilineTextFormField(
              controller: _equipmentController,
              label: "Equipment",
              hintText: "What exercise equipment is needed?",
              prefixIcon: Icons.fitness_center_outlined,
              isOptional: true,
              padding: widget.betweenFieldsPadding,
            ),
            MultilineTextFormField(
              controller: _instructionsController,
              label: "Instructions",
              hintText: "How to do the exercise?",
              prefixIcon: Icons.sports,
              minLength: ExerciseConstants.minInstructionsLength,
              maxLength: ExerciseConstants.maxInstructionsLength,
              padding: widget.betweenFieldsPadding,
            ),
            if (_selectedImageFiles != null &&
                _selectedImageFiles!.isNotEmpty) ...{_previewImages()},
            Padding(
              padding: widget.betweenFieldsPadding,
              child: FloatingActionButton(
                onPressed: () {
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => PickImagesDialog(
                        onSelect: (List<XFile> pickedFileList) {
                          setState(() {
                            if (_selectedImageFiles == null ||
                                _selectedImageFiles!.isEmpty) {
                              _selectedImageFiles = pickedFileList;
                            } else {
                              _selectedImageFiles!.addAll(pickedFileList);
                            }
                          });
                        },
                      ),
                    );
                  }
                },
                heroTag: 'multipleMedia',
                tooltip: 'Pick Multiple Media From Gallery',
                child: const Icon(Icons.photo_library),
              ),
            ),
            Padding(
              padding: widget.betweenFieldsPadding,
              child: ExerciseCreateButton(
                formKey: _formKey,
                nameController: _nameController,
                muscleGroupController: _muscleGroupController,
                equipmentController: _equipmentController,
                instructionsController: _instructionsController,
                selectedVisibility: _selectedVisibility,
                selectedDifficulty: _selectedDifficulty,
                selectedType: _selectedType,
                selectedImageFiles: _selectedImageFiles,
                onUpdate: widget.onUpdate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _muscleGroupController.dispose();
    _equipmentController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}
