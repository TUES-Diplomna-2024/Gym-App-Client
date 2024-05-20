import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gym_app_client/db_api/services/base_http_service.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_create_model.dart';
import 'package:gym_app_client/utils/common/enums/exercise_visibility.dart';
import 'package:gym_app_client/utils/common/service_result.dart';
import 'package:gym_app_client/utils/common/enums/http_methods.dart';

class ExerciseService extends BaseHttpService {
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

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "Exercise has been successfully created!");
    }

    return getServiceResult(statusCode, response.body);
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

    return getServiceResult(statusCode, response.body,
        badRequestMessage: "The specified exercise could not be found!");
  }

  Future<ServiceResult> updateExerciseById(
      String exerciseId, ExerciseUpdateModel exerciseUpdate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.put,
      subEndpoint: exerciseId,
      headers: await getHeaders(includeContentType: false),
      body: exerciseUpdate.toMap(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => updateExerciseById(exerciseId, exerciseUpdate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(statusCode, "Successfully updated!");
    }

    return getServiceResult(statusCode, response.body);
  }

  Future<ServiceResult> updateExerciseVisibilityById(
      String exerciseId, ExerciseVisibility visibility) async {
    final requestResult = await sendRequest(
      method: HttpMethods.put,
      subEndpoint: "$exerciseId/visibility",
      headers: await getHeaders(includeContentType: false),
      body: {"visibility": visibility.name},
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => updateExerciseVisibilityById(exerciseId, visibility),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "Visibility has been successfully updated!");
    }

    return getServiceResult(statusCode, response.body);
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

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "Exercise has been successfully deleted!");
    }

    return getServiceResult(statusCode, response.body,
        badRequestMessage: "The specified exercise could not be found!");
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

    final exercisePreviews =
        ExercisePreviewModel.getExercisePreviewsFromResponse(response);

    return ServiceResult.success(data: exercisePreviews);
  }

  Future<ServiceResult> getExerciseSearchResultsAdvanced(
      String exerciseName, ExerciseVisibility visibility) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint:
          "advanced-search?name=$exerciseName&visibility=${visibility.name}",
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

    return getServiceResult(statusCode, response.body);
  }

  Future<ServiceResult> getCurrUserCustomExercisePreviews() async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      fullUrl: Uri.parse("$dbAPIBaseUrl/users/current/custom-exercises"),
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getCurrUserCustomExercisePreviews(),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;

    final exercisePreviews =
        ExercisePreviewModel.getExercisePreviewsFromResponse(response);

    return ServiceResult.success(data: exercisePreviews);
  }
}
