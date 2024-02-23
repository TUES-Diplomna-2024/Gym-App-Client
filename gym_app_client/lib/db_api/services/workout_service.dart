import 'dart:io';
import 'package:gym_app_client/db_api/models/workout/workout_create_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_update_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:gym_app_client/utils/common/http_methods.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';
import 'package:gym_app_client/utils/common/service_result.dart';

class WorkoutService extends BaseService {
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

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
        message: "Workout has been successfully created!",
      );
    } else if (statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "Invalid workout data!");
    }

    return ServiceResult.fail(message: defaultErrorMessage);
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
    } else if (statusCode == HttpStatus.notFound ||
        statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "This workout could not be found!");
    } else if (statusCode == HttpStatus.forbidden) {
      return ServiceResult.fail(
        message: "You cannot access workouts that are owned by another user!",
      );
    }

    return ServiceResult.fail(message: defaultErrorMessage);
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
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
        data: WorkoutPreviewModel.getWorkoutPreviewsFromResponse(response),
      );
    }

    return ServiceResult.fail(message: defaultErrorMessage);
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

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(message: "Successfully updated!");
    } else if (statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "Invalid workout data!");
    } else if (statusCode == HttpStatus.notFound) {
      return ServiceResult.fail(message: "Workout could not be found!");
    } else if (statusCode == HttpStatus.forbidden) {
      return ServiceResult.fail(message: response.body);
    }

    return ServiceResult.fail(message: defaultErrorMessage);
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

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
          message: "Workout was successfully deleted!");
    } else if (statusCode == HttpStatus.notFound ||
        statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "Workout could not be found!");
    } else if (statusCode == HttpStatus.forbidden) {
      return ServiceResult.fail(message: response.body);
    }

    return ServiceResult.fail(message: defaultErrorMessage);
  }
}
