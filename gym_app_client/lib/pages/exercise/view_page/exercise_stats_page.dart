import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_stats_model.dart';
import 'package:gym_app_client/db_api/services/exercise_record_service.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/common/enums/statistic_measurement.dart';
import 'package:gym_app_client/utils/common/enums/statistic_period.dart';
import 'package:gym_app_client/utils/components/fields/form/statistic_measurement_form_field.dart';
import 'package:gym_app_client/utils/components/fields/form/time_period_form_field.dart';
import 'package:gym_app_client/utils/components/views/exercise_stats_view.dart';

class ExerciseStatsPage extends StatefulWidget {
  final String exerciseId;

  const ExerciseStatsPage({
    super.key,
    required this.exerciseId,
  });

  @override
  State<ExerciseStatsPage> createState() => _ExerciseStatsPageState();
}

class _ExerciseStatsPageState extends State<ExerciseStatsPage> {
  final _userService = UserService();
  final _exerciseRecordService = ExerciseRecordService();

  StatisticPeriod? _selectedPeriod;
  StatisticMeasurement? _selectedMeasurement;

  ExerciseStatsModel? _stats;
  bool _isLoading = false;

  void _getStats() {
    if (mounted && _selectedPeriod != null && _selectedMeasurement != null) {
      _exerciseRecordService
          .getCurrUserExerciseStatistics(
              widget.exerciseId, _selectedPeriod!, _selectedMeasurement!)
          .then(
        (serviceResult) {
          if (serviceResult.isSuccessful && mounted) {
            setState(() {
              _stats = serviceResult.data;
              _isLoading = true;
            });
          } else {
            serviceResult.showPopUp(context);
            if (serviceResult.shouldSignOutUser) _userService.signOut(context);
          }
        },
      );
    }
  }

  Widget _getStatsBody() {
    if (_selectedPeriod == null || _selectedMeasurement == null) {
      return const SizedBox();
    } else if (_isLoading == false) {
      return const Center(child: CircularProgressIndicator());
    } else if (_stats == null) {
      return const Center(
        child: Text(
          "No statistics available for the selected time period!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ExerciseStatsView(
      stats: _stats!,
      timePeriod: _selectedPeriod!,
      measurement: _selectedMeasurement!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 23),
            child: Column(
              children: [
                TimePeriodFormField(
                  onTimePeriodChanged: (StatisticPeriod? value) {
                    if (mounted) {
                      setState(() {
                        _selectedPeriod = value!;
                        _isLoading = false;
                      });
                    }
                    _getStats();
                  },
                ),
                const SizedBox(height: 23),
                StatisticMeasurementFormField(
                  onMeasurementChanged: (StatisticMeasurement? value) {
                    if (mounted) {
                      setState(() {
                        _selectedMeasurement = value!;
                        _isLoading = false;
                      });
                    }
                    _getStats();
                  },
                ),
                const SizedBox(height: 23),
                _getStatsBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
