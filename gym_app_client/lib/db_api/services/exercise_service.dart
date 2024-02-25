import 'dart:io';
import 'dart:convert';
import 'package:gym_app_client/db_api/models/exercise/exercise_statistics_model.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_create_model.dart';
import 'package:gym_app_client/utils/common/service_result.dart';
import 'package:gym_app_client/utils/common/http_methods.dart';

class ExerciseService extends BaseService {
  ExerciseService() : super(baseEndpoint: "exercises");

  Future<ServiceResult> createNewExercise(
      ExerciseCreateModel exerciseCreate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.post,
      subEndpoint: "create",
      headers: await getHeaders(includeContentType: false),
      body: exerciseCreate.toMap(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => createNewExercise(exerciseCreate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Exercise has been successfully created!",
      HttpStatus.badRequest: "Invalid exercise data!",
      HttpStatus.forbidden: response.body,
    });
  }

  Future<ServiceResult> getExerciseById(String exerciseId) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: exerciseId,
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getExerciseById(exerciseId),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
        data: ExerciseViewModel.loadFromResponse(response),
      );
    }

    return getServiceResult(statusCode, {
      HttpStatus.notFound: "Exercise could not be found!",
      HttpStatus.badRequest: "Exercise could not be found!",
      HttpStatus.forbidden: response.body,
    });
  }

  Future<ServiceResult> getExerciseSearchResults(String exerciseName) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: "search?name=$exerciseName",
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getExerciseSearchResults(exerciseName),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      final exercisePreviews =
          ExercisePreviewModel.getExercisePreviewsFromResponse(response);

      return ServiceResult.success(data: exercisePreviews);
    }

    return ServiceResult.fail(message: defaultErrorMessage);
  }

  Future<ServiceResult> getCurrUserExerciseStatistics(
      String exerciseId, String period, String measurement) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: "stats?period=$period&measurement=$measurement",
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
      final exerciseStatistics =
          ExerciseStatisticsModel.loadFromResponse(response);

      return ServiceResult.success(data: exerciseStatistics);
    }

    return getServiceResult(statusCode, {
      HttpStatus.noContent: "No statistics found for the selected time period!",
      HttpStatus.badRequest:
          "The provided time period or measurement is invalid!",
      HttpStatus.notFound: "Exercise could not be found!",
      HttpStatus.forbidden: response.body,
    });
  }

  Future<ServiceResult> addExerciseInWorkouts(
      String exerciseId, List<String> workoutIds) async {
    final requestResult = await sendRequest(
      method: HttpMethods.post,
      subEndpoint: "$exerciseId/add-in-workouts",
      headers: await getHeaders(),
      body: jsonEncode(workoutIds),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => addExerciseInWorkouts(exerciseId, workoutIds),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    return getServiceResult(statusCode, {
      HttpStatus.ok: response.body.isEmpty
          ? "Exercise has been successfully added in ${workoutIds.length} workout/s!"
          : "Exercise was not added in all workouts!",
      HttpStatus.notFound: "Exercise could not be found!",
      HttpStatus.badRequest: "Exercise was not added in any workout!",
      HttpStatus.forbidden: response.body,
    });
  }

  Future<ServiceResult> updateExerciseById(
      String exerciseId, ExerciseUpdateModel exerciseUpdate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.put,
      subEndpoint: exerciseId,
      headers: await getHeaders(),
      body: exerciseUpdate.toJson(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => updateExerciseById(exerciseId, exerciseUpdate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Successfully updated!",
      HttpStatus.badRequest: "Invalid exercise data!",
      HttpStatus.notFound: "Exercise could not be found!",
      HttpStatus.forbidden: response.body,
    });
  }

  Future<ServiceResult> deleteExerciseById(String exerciseId) async {
    final requestResult = await sendRequest(
      method: HttpMethods.delete,
      subEndpoint: exerciseId,
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => deleteExerciseById(exerciseId),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Exercise was successfully deleted!",
      HttpStatus.notFound: "Exercise could not be found!",
      HttpStatus.badRequest: "Exercise could not be found!",
      HttpStatus.forbidden: response.body,
    });
  }
}
