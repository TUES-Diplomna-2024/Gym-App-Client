import 'dart:io';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_create_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise_record/exercise_record_view_model.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';
import 'package:gym_app_client/utils/common/http_methods.dart';
import 'package:gym_app_client/utils/common/service_result.dart';

class ExerciseRecordService extends BaseService {
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

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Record has been successfully created!",
      HttpStatus.badRequest: "Invalid record data!",
      HttpStatus.notFound: "Exercise could not be found!",
      HttpStatus.forbidden: response.body,
    });
  }

  Future<ServiceResult> getCurrUserExerciseRecordsViews(
      String exerciseId, String period) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: "$exerciseId/records?period=$period",
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

    return getServiceResult(statusCode, {
      HttpStatus.badRequest: "Invalid data provided!",
      HttpStatus.notFound: "Exercise could not be found!",
      HttpStatus.forbidden: response.body,
    });
  }

  Future<ServiceResult> updateExerciseRecordById(String exerciseId,
      String recordId, ExerciseRecordCreateUpdateModel recordUpdate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.put,
      subEndpoint: "$exerciseId/records/$recordId",
      headers: await getHeaders(),
      body: recordUpdate.toJson(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () =>
          updateExerciseRecordById(exerciseId, recordId, recordUpdate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Successfully updated!",
      HttpStatus.badRequest: "Invalid data provided!",
      HttpStatus.notFound: "${response.body.split(' ')[0]} could not be found!",
      HttpStatus.forbidden: response.body,
    });
  }

  Future<ServiceResult> deleteExerciseRecordById(
      String exerciseId, String recordId) async {
    final requestResult = await sendRequest(
      method: HttpMethods.delete,
      subEndpoint: "$exerciseId/records/$recordId",
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => deleteExerciseRecordById(exerciseId, recordId),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Record was successfully deleted!",
      HttpStatus.badRequest: "Invalid data provided!",
      HttpStatus.notFound: "${response.body.split(' ')[0]} could not be found!",
      HttpStatus.forbidden: response.body,
    });
  }
}
