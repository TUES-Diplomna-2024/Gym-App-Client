import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/db_api/models/exercise_image/exercise_image_view_model.dart';
import 'package:gym_app_client/utils/common/enums/exercise_difficulty.dart';
import 'package:gym_app_client/utils/common/enums/exercise_type.dart';
import 'package:gym_app_client/utils/components/buttons/exercise/exercise_save_changes_button.dart';
import 'package:gym_app_client/utils/components/dialogs/pick_images_dialog.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_difficulty_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/exercise_type_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/multiline_text_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/components/views/previews/image_preview.dart';
import 'package:gym_app_client/utils/constants/exercise_constants.dart';
import 'package:image_picker/image_picker.dart';

class ExerciseEditForm extends StatefulWidget {
  final ExerciseViewModel exerciseInitState;
  final void Function() onUpdate;
  late final EdgeInsets formPadding;
  late final EdgeInsets betweenFieldsPadding;

  ExerciseEditForm({
    super.key,
    required this.exerciseInitState,
    required this.onUpdate,
    required EdgeInsets padding,
  }) {
    formPadding = EdgeInsets.only(
      top: padding.top,
      left: padding.left,
      right: padding.right,
    );

    betweenFieldsPadding = EdgeInsets.only(bottom: padding.bottom);
  }

  @override
  State<ExerciseEditForm> createState() => _ExerciseEditFormState();
}

class _ExerciseEditFormState extends State<ExerciseEditForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _muscleGroupController;
  late final TextEditingController _equipmentController;
  late final TextEditingController _instructionsController;

  late ExerciseDifficulty _selectedDifficulty;
  late ExerciseType _selectedType;

  List<String> _toBeRemovedImageIds = [];
  List<XFile> _toBeAddedImageFiles = [];
  List<dynamic> _displayedImages = [];

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.exerciseInitState.name);
    _muscleGroupController =
        TextEditingController(text: widget.exerciseInitState.muscleGroups);
    _equipmentController =
        TextEditingController(text: widget.exerciseInitState.equipment);
    _instructionsController =
        TextEditingController(text: widget.exerciseInitState.instructions);

    _selectedDifficulty = widget.exerciseInitState.difficulty;
    _selectedType = widget.exerciseInitState.type;

    if (widget.exerciseInitState.images != null) {
      _displayedImages.addAll(widget.exerciseInitState.images!);
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _muscleGroupController.dispose();
    _equipmentController.dispose();
    _instructionsController.dispose();

    super.dispose();
  }

  Widget _previewImages() {
    if (_displayedImages.isEmpty) {
      return Padding(
        padding: widget.betweenFieldsPadding,
        child: const Text(
          'You can add images to this exercise!',
          textAlign: TextAlign.center,
        ),
      );
    }
    return Semantics(
      child: SizedBox(
        height: 300,
        child: ListView.builder(
          key: UniqueKey(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return ImagePreview(
              image: (_displayedImages[index] is XFile)
                  ? Image.file(File(_displayedImages[index].path))
                  : (_displayedImages[index] as ExerciseImageViewModel).image,
              onRemove: () {
                if (context.mounted) {
                  if (_displayedImages[index] is XFile) {
                    _toBeAddedImageFiles.remove(_displayedImages[index]);
                  } else {
                    _toBeRemovedImageIds.add(
                        (_displayedImages[index] as ExerciseImageViewModel).id);
                  }

                  setState(() => _displayedImages.removeAt(index));
                }
              },
            );
          },
          itemCount: _displayedImages.length,
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
            ExerciseDifficultyFormField(
              defaultDifficulty: _selectedDifficulty,
              onDifficultyChanged: (ExerciseDifficulty? difficulty) {
                if (mounted) setState(() => _selectedDifficulty = difficulty!);
              },
              padding: widget.betweenFieldsPadding,
            ),
            ExerciseTypeFormField(
              defaultType: _selectedType,
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
            _previewImages(),
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
                            _displayedImages.addAll(pickedFileList);
                            _toBeAddedImageFiles.addAll(pickedFileList);
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
              child: ExerciseSaveChangesButton(
                formKey: _formKey,
                exerciseId: widget.exerciseInitState.id,
                nameController: _nameController,
                muscleGroupController: _muscleGroupController,
                equipmentController: _equipmentController,
                instructionsController: _instructionsController,
                selectedDifficulty: _selectedDifficulty,
                selectedType: _selectedType,
                imagesToBeRemoved: _toBeRemovedImageIds,
                imagesToBeAdded: _toBeAddedImageFiles,
                onUpdate: widget.onUpdate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
