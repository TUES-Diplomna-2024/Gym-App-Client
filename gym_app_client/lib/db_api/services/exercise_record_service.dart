import 'dart:io';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_create_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_view_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_stats_model.dart';
import 'package:gym_app_client/utils/common/enums/statistic_period.dart';
import 'package:gym_app_client/utils/common/enums/statistic_measurement.dart';
import 'package:gym_app_client/db_api/services/base_http_service.dart';
import 'package:gym_app_client/utils/common/enums/http_methods.dart';
import 'package:gym_app_client/utils/common/service_result.dart';

class ExerciseRecordService extends BaseHttpService {
  ExerciseRecordService() : super(baseEndpoint: "exercises");

  Future<ServiceResult> createNewExerciseRecord(
      String exerciseId, ExerciseRecordCreateUpdateModel recordCreate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.post,
      subEndpoint: "$exerciseId/records/create",
      headers: await getHeaders(),
      body: recordCreate.toJson(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => createNewExerciseRecord(exerciseId, recordCreate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "Exercise record has been successfully created!");
    }

    return getServiceResult(statusCode, response.body);
  }

  Future<ServiceResult> getCurrUserExerciseRecordsViews(
      String exerciseId, StatisticPeriod period) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: "$exerciseId/records?period=${period.index}",
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getCurrUserExerciseRecordsViews(exerciseId, period),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      final recordViews =
          ExerciseRecordViewModel.getRecordViewsFromResponse(response);

      return ServiceResult.success(data: recordViews);
    }

    return getServiceResult(statusCode, response.body);
  }

  Future<ServiceResult> getCurrUserExerciseStatistics(String exerciseId,
      StatisticPeriod period, StatisticMeasurement measurement) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint:
          "$exerciseId/stats?period=${period.index}&measurement=${measurement.index}",
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () =>
          getCurrUserExerciseStatistics(exerciseId, period, measurement),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      final exerciseStatistics = ExerciseStatsModel.loadFromResponse(response);

      return ServiceResult.success(data: exerciseStatistics);
    } else if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "No statistics available for the selected time period!");
    }

    return getServiceResult(statusCode, response.body);
  }

  Future<ServiceResult> updateExerciseRecordById(
      String recordId, ExerciseRecordCreateUpdateModel recordUpdate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.put,
      fullUrl: Uri.parse("$dbAPIBaseUrl/exercises/records/$recordId"),
      headers: await getHeaders(),
      body: recordUpdate.toJson(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => updateExerciseRecordById(recordId, recordUpdate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(statusCode, "Successfully updated!");
    }

    return getServiceResult(statusCode, response.body);
  }

  Future<ServiceResult> deleteExerciseRecordById(String recordId) async {
    final requestResult = await sendRequest(
      method: HttpMethods.delete,
      fullUrl: Uri.parse("$dbAPIBaseUrl/exercises/records/$recordId"),
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => deleteExerciseRecordById(recordId),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "Exercise record has been successfully deleted!");
    }

    return getServiceResult(statusCode, response.body,
        badRequestMessage: "The specified exercise record could not be found!");
  }
}
