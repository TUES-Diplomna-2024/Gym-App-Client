import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:gym_app_client/db_api/models/auth_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signin_model.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/utils/common/popup_info.dart';
import 'package:gym_app_client/utils/common/service_result.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';

class UserService extends BaseService {
  UserService() : super(baseEndpoint: "users");

  Future<PopUpInfo> signUp(UserSignUpModel userSignUp) async {
    try {
      final response = await post(
        getUri("signup"),
        headers:
            await getHeaders(hasAccessToken: false, hasRefreshToken: false),
        body: userSignUp.toJson(),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.ok) {
        final tokens = AuthModel.loadFromResponse(response);
        tokenService.saveTokensInStorage(tokens);

        return success("Your account has been successfully created!");
      } else if (statusCode == HttpStatus.badRequest) {
        return fail("Invalid user data!");
      } else if (statusCode == HttpStatus.conflict) {
        return fail("This email address is already in use!");
      }

      throw Exception();
    } on SocketException {
      return fail(
          "Network error! Please check your internet connection and try again!");
    } on Exception {
      return fail("Something went wrong! Try again later!");
    }
  }

  Future<PopUpInfo> signIn(UserSignInModel userSignIn) async {
    try {
      final response = await post(
        getUri("signin"),
        headers:
            await getHeaders(hasAccessToken: false, hasRefreshToken: false),
        body: userSignIn.toJson(),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.ok) {
        final tokens = AuthModel.loadFromResponse(response);
        tokenService.saveTokensInStorage(tokens);

        return success("Welcome back!");
      } else if (statusCode == HttpStatus.badRequest) {
        return fail("Invalid user data!");
      } else if (statusCode == HttpStatus.unauthorized) {
        return fail("Sign in or password is invalid!");
      }

      throw Exception();
    } on SocketException {
      return fail(
          "Network error! Please check your internet connection and try again!");
    } on Exception {
      return fail("Something went wrong! Try again later!");
    }
  }

  Future<ServiceResult> getCurrUser() async {
    try {
      final response = await get(
        getUri("current"),
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

        return await getCurrUser();
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        return ServiceResult(data: UserProfileModel.loadFromResponse(response));
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

  Future<ServiceResult> getUserById(String userId) async {
    try {
      final response = await get(
        getUri(userId),
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

        return await getUserById(userId);
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        return ServiceResult(data: UserProfileModel.loadFromResponse(response));
      } else if (statusCode == HttpStatus.notFound ||
          statusCode == HttpStatus.badRequest) {
        return ServiceResult(popUpInfo: fail("This user could not be found!"));
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

  Future<ServiceResult> getCurrUserCustomExercisePreviews() async {
    try {
      final response = await get(
        getUri("current/custom-exercises"),
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

        return await getCurrUserCustomExercisePreviews();
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        final exercisePreviews =
            ExercisePreviewModel.getExercisePreviewsFromResponse(response);

        return ServiceResult(data: exercisePreviews);
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

  Future<ServiceResult> updateCurrUser(UserUpdateModel userUpdate) async {
    try {
      final response = await put(
        getUri("current"),
        headers: await getHeaders(),
        body: userUpdate.toJson(),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.unauthorized) {
        var error = await refreshAccessToken();

        if (error != null) {
          return ServiceResult(
              popUpInfo: error.popUpInfo,
              shouldSignOutUser: error.shouldSignOutUser);
        }

        return await updateCurrUser(userUpdate);
      }

      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);

      if (statusCode == HttpStatus.ok) {
        return ServiceResult(popUpInfo: success("Successfully updated!"));
      } else if (statusCode == HttpStatus.badRequest) {
        return ServiceResult(popUpInfo: fail("Invalid user data!"));
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

  Future<ServiceResult> deleteCurrUser(String password) async {
    try {
      final response = await delete(
        getUri("current"),
        headers: await getHeaders(),
        body: jsonEncode({"password": password}),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.unauthorized) {
        if (response.body == "Incorrect password!") {
          return ServiceResult(popUpInfo: fail("Incorrect password!"));
        }

        var error = await refreshAccessToken();

        if (error != null) {
          return ServiceResult(
              popUpInfo: error.popUpInfo,
              shouldSignOutUser: error.shouldSignOutUser);
        }

        return await deleteCurrUser(password);
      }

      if (statusCode == HttpStatus.ok) {
        await tokenService.removeTokensFromStorage();
        return ServiceResult(
            popUpInfo: success("Your account is deleted successfully!"),
            shouldSignOutUser: true);
      } else if (statusCode == HttpStatus.badRequest) {
        return ServiceResult(popUpInfo: fail("Invalid password format!"));
      } else if (statusCode == HttpStatus.forbidden) {
        return ServiceResult(
            popUpInfo: fail("As a root admin you cannot delete your account!"));
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
