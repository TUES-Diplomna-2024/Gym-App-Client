import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:gym_app_client/utils/components/fields/form/multiline_text_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/name_form_field.dart';
import 'package:gym_app_client/utils/components/views/previews/exercise_preview.dart';
import 'package:gym_app_client/utils/components/buttons/workout/workout_save_changes_button.dart';
import 'package:gym_app_client/utils/constants/workout_constants.dart';

class WorkoutEditForm extends StatefulWidget {
  final WorkoutViewModel workoutInitState;
  final void Function(String, String?, List<ExercisePreviewModel>?)
      onWorkoutUpdated;
  late final EdgeInsets formPadding;
  late final EdgeInsets betweenFieldsPadding;

  WorkoutEditForm({
    super.key,
    required this.workoutInitState,
    required this.onWorkoutUpdated,
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
  State<WorkoutEditForm> createState() => _WorkoutEditFormState();
}

class _WorkoutEditFormState extends State<WorkoutEditForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  List<ExercisePreviewModel>? _exercises;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.workoutInitState.name);
    _descriptionController =
        TextEditingController(text: widget.workoutInitState.description);

    if (widget.workoutInitState.exercises != null) {
      _exercises = List.from(widget.workoutInitState.exercises!);
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();

    super.dispose();
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
              hintText: "Enter workout name",
              prefixIcon: Icons.title_outlined,
              minLength: WorkoutConstants.minNameLength,
              maxLength: WorkoutConstants.maxNameLength,
              padding: widget.betweenFieldsPadding,
            ),
            MultilineTextFormField(
              controller: _descriptionController,
              label: "Description",
              hintText: "Enter workout description",
              prefixIcon: Icons.description_outlined,
              maxLength: WorkoutConstants.maxDescriptionLength,
              isOptional: true,
              padding: widget.betweenFieldsPadding,
            ),
            if (_exercises != null && _exercises!.isNotEmpty) ...{
              Theme(
                data: ThemeData(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  dialogBackgroundColor: Colors.transparent,
                ),
                child: ReorderableListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  buildDefaultDragHandles: _exercises!.length > 1,
                  itemBuilder: (_, int index) {
                    return Slidable(
                      key: ValueKey(_exercises![index]),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (context.mounted) {
                                setState(() => _exercises!.removeAt(index));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.red.shade400,
                              padding: const EdgeInsets.all(10),
                            ),
                            child: const Icon(Icons.remove),
                          )
                        ],
                      ),
                      child: ExercisePreview(
                        exercise: _exercises![index],
                      ),
                    );
                  },
                  itemCount: _exercises!.length,
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) newIndex--;

                    setState(() {
                      ExercisePreviewModel exercise = _exercises![oldIndex];

                      _exercises!.removeAt(oldIndex);
                      _exercises!.insert(newIndex, exercise);
                    });
                  },
                ),
              ),
            },
            WorkoutSaveChangesButton(
              formKey: _formKey,
              workoutId: widget.workoutInitState.id,
              nameController: _nameController,
              descriptionController: _descriptionController,
              exercises: _exercises,
              onWorkoutUpdated: widget.onWorkoutUpdated,
            ),
          ],
        ),
      ),
    );
  }
}
