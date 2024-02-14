import 'dart:io';
import 'package:gym_app_client/db_api/models/workout/workout_preview_model.dart';
import 'package:gym_app_client/db_api/models/workout/workout_view_model.dart';
import 'package:http/http.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';
import 'package:gym_app_client/utils/common/service_result.dart';

class WorkoutService extends BaseService {
  WorkoutService() : super(baseEndpoint: "users/current/workouts");

  Future<ServiceResult> getCurrUserWorkoutPreviews() async {
    try {
      final response = await get(
        getUri(),
        headers: await getHeaders(),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.unauthorized) {
        var error = await refreshAccessToken();

        if (error != null) {
          return ServiceResult(
              popUpInfo: error.popUpInfo,
              shouldSignOutUser: error.shouldSignOutUser);
        }

        return await getCurrUserWorkoutPreviews();
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        return ServiceResult(
            data: WorkoutPreviewModel.getWorkoutPreviewsFromResponse(response));
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

  Future<ServiceResult> getWorkoutById(String workoutId) async {
    try {
      final response = await get(
        getUri(subEndpoint: workoutId),
        headers: await getHeaders(),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.unauthorized) {
        var error = await refreshAccessToken();

        if (error != null) {
          return ServiceResult(
              popUpInfo: error.popUpInfo,
              shouldSignOutUser: error.shouldSignOutUser);
        }

        return await getWorkoutById(workoutId);
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        return ServiceResult(
          data: WorkoutViewModel.loadFromResponse(response),
        );
      } else if (statusCode == HttpStatus.notFound) {
        return ServiceResult(
          popUpInfo: fail("This workout could not be found!"),
        );
      } else if (statusCode == HttpStatus.forbidden) {
        return ServiceResult(
          popUpInfo: fail(
              "You cannot access workouts that are owned by another user!"),
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
}
