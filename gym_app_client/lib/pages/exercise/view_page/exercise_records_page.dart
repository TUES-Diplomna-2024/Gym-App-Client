import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_view_model.dart';
import 'package:gym_app_client/db_api/services/exercise_record_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/dialogs/exercise_record_create_dialog.dart';
import 'package:gym_app_client/utils/components/dialogs/exercise_record_delete_dialog.dart';
import 'package:gym_app_client/utils/components/dialogs/exercise_record_edit_dialog.dart';
import 'package:gym_app_client/utils/components/fields/form/time_period_form_field.dart';
import 'package:gym_app_client/utils/components/views/exercise_record_view.dart';

class ExerciseRecordsPage extends StatefulWidget {
  final String exerciseId;

  const ExerciseRecordsPage({
    super.key,
    required this.exerciseId,
  });

  @override
  State<ExerciseRecordsPage> createState() => _ExerciseRecordsPageState();
}

class _ExerciseRecordsPageState extends State<ExerciseRecordsPage> {
  final _userService = UserService();
  final _exerciseRecordService = ExerciseRecordService();

  String _selectedPeriod = "";
  List<ExerciseRecordViewModel>? _records;

  void _getRecords() {
    if (mounted && _selectedPeriod.isNotEmpty) {
      _exerciseRecordService
          .getCurrUserExerciseRecordsViews(widget.exerciseId, _selectedPeriod)
          .then(
        (serviceResult) {
          if (serviceResult.isSuccessful) {
            if (mounted) setState(() => _records = serviceResult.data!);
          } else {
            serviceResult.showPopUp(context);
            if (serviceResult.shouldSignOutUser) _userService.signOut(context);
          }
        },
      );
    }
  }

  Widget _getRecordsBody() {
    if (_records == null) {
      return const SizedBox();
    }

    if (_records!.isEmpty) {
      return const Center(
        child: Text(
          "No records found!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: _records!.length,
      itemBuilder: (_, int index) {
        return Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.4,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => ExerciseRecordDeleteDialog(
                        context: context,
                        exerciseId: widget.exerciseId,
                        recordId: _records![index].id,
                        updatePage: _getRecords,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.red.shade400,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(Icons.delete),
              ),
              ElevatedButton(
                onPressed: () {
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => ExerciseRecordEditDialog(
                        exerciseId: widget.exerciseId,
                        recordInitState: _records![index],
                        updatePage: _getRecords,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.amber.shade400,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(Icons.edit),
              )
            ],
          ),
          child: ExerciseRecordView(record: _records![index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 23),
        child: Column(
          children: [
            TimePeriodFormField(
              onTimePeriodChanged: (String? value) {
                if (mounted) setState(() => _selectedPeriod = value!);
                _getRecords();
              },
            ),
            const SizedBox(height: 23),
            Expanded(
              child: _getRecordsBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () {
            if (mounted) {
              showDialog(
                context: context,
                builder: (_) => ExerciseRecordCreateDialog(
                  exerciseId: widget.exerciseId,
                  updatePage: _getRecords,
                ),
              );
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
