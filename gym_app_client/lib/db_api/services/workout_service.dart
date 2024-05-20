import 'dart:convert';
import 'dart:io';
import 'package:gym_app_client/db_api/models/workout/workout_create_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_update_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:gym_app_client/db_api/services/base_http_service.dart';
import 'package:gym_app_client/utils/common/enums/http_methods.dart';
import 'package:gym_app_client/utils/common/service_result.dart';

class WorkoutService extends BaseHttpService {
  WorkoutService() : super(baseEndpoint: "users/current/workouts");

  Future<ServiceResult> createNewWorkout(
      WorkoutCreateModel workoutCreate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.post,
      subEndpoint: "create",
      headers: await getHeaders(),
      body: workoutCreate.toJson(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => createNewWorkout(workoutCreate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final statusCode = requestResult.response!.statusCode;

    return getServiceResult(
        statusCode, "Workout has been successfully created!");
  }

  Future<ServiceResult> getCurrUserWorkoutPreviews() async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getCurrUserWorkoutPreviews(),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;

    return ServiceResult.success(
      data: WorkoutPreviewModel.getWorkoutPreviewsFromResponse(response),
    );
  }

  Future<ServiceResult> getWorkoutById(String workoutId) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: workoutId,
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getWorkoutById(workoutId),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
        data: WorkoutViewModel.loadFromResponse(response),
      );
    }

    return getServiceResult(statusCode, response.body,
        badRequestMessage: "The specified workout could not be found!");
  }

  Future<ServiceResult> updateWorkoutById(
      String workoutId, WorkoutUpdateModel workoutUpdate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.put,
      subEndpoint: workoutId,
      headers: await getHeaders(),
      body: workoutUpdate.toJson(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => updateWorkoutById(workoutId, workoutUpdate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(statusCode, "Successfully updated!");
    }

    return getServiceResult(statusCode, response.body);
  }

  Future<ServiceResult> deleteWorkoutById(String workoutId) async {
    final requestResult = await sendRequest(
      method: HttpMethods.delete,
      subEndpoint: workoutId,
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => deleteWorkoutById(workoutId),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "Workout has been successfully deleted!");
    }

    return getServiceResult(statusCode, response.body,
        badRequestMessage: "The specified workout could not be found!");
  }

  Future<ServiceResult> addExerciseToWorkouts(
      String exerciseId, List<String> workoutIds) async {
    final requestResult = await sendRequest(
      method: HttpMethods.post,
      fullUrl: Uri.parse("$dbAPIBaseUrl/exercises/$exerciseId/add-to-workouts"),
      headers: await getHeaders(),
      body: jsonEncode(workoutIds),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => addExerciseToWorkouts(exerciseId, workoutIds),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(statusCode,
          "Exercise has been successfully added to ${workoutIds.length} workout(s)!");
    }

    return getServiceResult(statusCode, response.body);
  }
}
