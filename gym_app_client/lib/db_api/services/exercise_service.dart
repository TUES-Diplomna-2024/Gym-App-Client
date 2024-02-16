import 'dart:convert';
import 'dart:io';
import 'package:gym_app_client/db_api/models/exercise/exercise_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_view_model.dart';
import 'package:http/http.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_create_model.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';
import 'package:gym_app_client/utils/common/service_result.dart';

class ExerciseService extends BaseService {
  ExerciseService() : super(baseEndpoint: "exercises");

  Future<ServiceResult> createNewExercise(
      ExerciseCreateModel exerciseCreate) async {
    try {
      final response = await post(
        getUri(subEndpoint: "create"),
        headers: await getHeaders(includeContentType: false),
        body: exerciseCreate.toMap(),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.unauthorized) {
        var error = await refreshAccessToken();

        if (error != null) {
          return ServiceResult(
            popUpInfo: error.popUpInfo,
            shouldSignOutUser: error.shouldSignOutUser,
          );
        }

        return await createNewExercise(exerciseCreate);
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        return ServiceResult(
          popUpInfo: success("Exercise has been successfully created!"),
        );
      } else if (statusCode == HttpStatus.badRequest) {
        return ServiceResult(
          popUpInfo: fail("Invalid exercise data!"),
        );
      } else if (statusCode == HttpStatus.forbidden) {
        return ServiceResult(
          popUpInfo: fail("Only admin users can create public exercises!"),
        );
      }

      throw Exception();
    } on SocketException {
      return ServiceResult(
          popUpInfo: fail(
              "Network error! Please check your internet connection and try again!"));
    } on Exception {
      return ServiceResult(
          popUpInfo: fail("Something went wrong! Try again later!"));
    }
  }

  Future<ServiceResult> getExerciseById(String exerciseId) async {
    try {
      final response = await get(
        getUri(subEndpoint: exerciseId),
        headers: await getHeaders(),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.unauthorized) {
        var error = await refreshAccessToken();

        if (error != null) {
          return ServiceResult(
            popUpInfo: error.popUpInfo,
            shouldSignOutUser: error.shouldSignOutUser,
          );
        }

        return await getExerciseById(exerciseId);
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        return ServiceResult(
          data: ExerciseViewModel.loadFromResponse(response),
        );
      } else if (statusCode == HttpStatus.notFound) {
        return ServiceResult(popUpInfo: fail("Exercise could not be found!"));
      } else if (statusCode == HttpStatus.forbidden) {
        return ServiceResult(
            popUpInfo: fail(
                "You cannot access custom exercises that are owned by another user!"));
      }

      throw Exception();
    } on SocketException {
      return ServiceResult(
          popUpInfo: fail(
              "Network error! Please check your internet connection and try again!"));
    } on Exception {
      return ServiceResult(
          popUpInfo: fail("Something went wrong! Try again later!"));
    }
  }

  Future<ServiceResult> addExerciseInWorkouts(
      String exerciseId, List<String> workoutIds) async {
    try {
      final response = await post(
        getUri(subEndpoint: "$exerciseId/add-in-workouts"),
        headers: await getHeaders(),
        body: jsonEncode(workoutIds),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.unauthorized) {
        var error = await refreshAccessToken();

        if (error != null) {
          return ServiceResult(
            popUpInfo: error.popUpInfo,
            shouldSignOutUser: error.shouldSignOutUser,
          );
        }

        return await addExerciseInWorkouts(exerciseId, workoutIds);
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        String message = response.body.isEmpty
            ? "Exercise has been successfully added in ${workoutIds.length} workout${workoutIds.length > 1 ? 's' : ''}!"
            : "Exercise was not added in all workouts!";

        return ServiceResult(
          popUpInfo: success(message),
        );
      } else if (statusCode == HttpStatus.notFound) {
        return ServiceResult(
          popUpInfo: fail("Exercise could not be found!"),
        );
      } else if (statusCode == HttpStatus.forbidden) {
        return ServiceResult(
          popUpInfo: fail(response.body),
        );
      } else if (statusCode == HttpStatus.badRequest) {
        return ServiceResult(
          popUpInfo: fail("Exercise was not added in any workout!"),
        );
      }

      throw Exception();
    } on SocketException {
      return ServiceResult(
          popUpInfo: fail(
              "Network error! Please check your internet connection and try again!"));
    } on Exception {
      return ServiceResult(
          popUpInfo: fail("Something went wrong! Try again later!"));
    }
  }

  Future<ServiceResult> updateExerciseById(
      String exerciseId, ExerciseUpdateModel exerciseUpdate) async {
    try {
      final response = await put(
        getUri(subEndpoint: exerciseId),
        headers: await getHeaders(),
        body: exerciseUpdate.toJson(),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.unauthorized) {
        var error = await refreshAccessToken();

        if (error != null) {
          return ServiceResult(
              popUpInfo: error.popUpInfo,
              shouldSignOutUser: error.shouldSignOutUser);
        }

        return await updateExerciseById(exerciseId, exerciseUpdate);
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        return ServiceResult(popUpInfo: success("Successfully updated!"));
      } else if (statusCode == HttpStatus.badRequest) {
        return ServiceResult(popUpInfo: fail("Invalid user data!"));
      } else if (statusCode == HttpStatus.notFound) {
        return ServiceResult(popUpInfo: fail("Exercise could not be found!"));
      } else if (statusCode == HttpStatus.forbidden) {
        return ServiceResult(popUpInfo: fail(response.body));
      }

      throw Exception();
    } on SocketException {
      return ServiceResult(
          popUpInfo: fail(
              "Network error! Please check your internet connection and try again!"));
    } on Exception {
      return ServiceResult(
          popUpInfo: fail("Something went wrong! Try again later!"));
    }
  }
}
