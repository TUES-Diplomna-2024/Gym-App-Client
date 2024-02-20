import 'dart:io';
import 'dart:convert';
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

    final statusCode = requestResult.response!.statusCode;

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
        message: "Exercise has been successfully created!",
      );
    } else if (statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "Invalid exercise data!");
    } else if (statusCode == HttpStatus.forbidden) {
      return ServiceResult.fail(
        message: "Only admin users can create public exercises!",
      );
    }

    return ServiceResult.fail(message: defaultErrorMessage);
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
    } else if (statusCode == HttpStatus.notFound ||
        statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "Exercise could not be found!");
    } else if (statusCode == HttpStatus.forbidden) {
      return ServiceResult.fail(
        message:
            "You cannot access custom exercises that are owned by another user!",
      );
    }

    return ServiceResult.fail(message: defaultErrorMessage);
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

    if (statusCode == HttpStatus.ok) {
      String message = response.body.isEmpty
          ? "Exercise has been successfully added in ${workoutIds.length} workout${workoutIds.length > 1 ? 's' : ''}!"
          : "Exercise was not added in all workouts!";

      return ServiceResult.success(message: message);
    } else if (statusCode == HttpStatus.notFound ||
        statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "Exercise could not be found!");
    } else if (statusCode == HttpStatus.forbidden) {
      return ServiceResult.fail(message: response.body);
    } else if (statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(
        message: "Exercise was not added in any workout!",
      );
    }

    return ServiceResult.fail(message: defaultErrorMessage);
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

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(message: "Successfully updated!");
    } else if (statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "Invalid user data!");
    } else if (statusCode == HttpStatus.notFound) {
      return ServiceResult.fail(message: "Exercise could not be found!");
    } else if (statusCode == HttpStatus.forbidden) {
      return ServiceResult.fail(message: response.body);
    }

    return ServiceResult.fail(message: defaultErrorMessage);
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

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(message: "Successfully deleted!");
    } else if (statusCode == HttpStatus.notFound ||
        statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: "Exercise could not be found!");
    } else if (statusCode == HttpStatus.forbidden) {
      return ServiceResult.fail(message: response.body);
    }

    return ServiceResult.fail(message: defaultErrorMessage);
  }
}
