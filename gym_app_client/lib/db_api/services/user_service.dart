import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/common/http_methods.dart';
import 'package:gym_app_client/utils/common/service_result.dart';
import 'package:gym_app_client/db_api/models/auth_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signin_model.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';
import 'package:gym_app_client/db_api/models/exercise/exercise_preview_model.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';

class UserService extends BaseService {
  UserService() : super(baseEndpoint: "users");

  Future<ServiceResult> signUp(UserSignUpModel userSignUp) async {
    final requestResult = await sendRequest(
      method: HttpMethods.post,
      subEndpoint: "signup",
      headers: await getHeaders(hasAccessToken: false, hasRefreshToken: false),
      body: userSignUp.toJson(),
    );

    if (!requestResult.isSuccessful) {
      return ServiceResult.fail(message: requestResult.errorMessage!);
    }

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      final tokens = AuthModel.loadFromResponse(response);
      await tokenService.saveTokensInStorage(tokens);
    }

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Your account has been successfully created!",
      HttpStatus.badRequest: "Invalid user data!",
      HttpStatus.conflict: "This email address is already in use!",
    });
  }

  Future<ServiceResult> signIn(UserSignInModel userSignIn) async {
    final requestResult = await sendRequest(
      method: HttpMethods.post,
      subEndpoint: "signin",
      headers: await getHeaders(hasAccessToken: false, hasRefreshToken: false),
      body: userSignIn.toJson(),
    );

    if (!requestResult.isSuccessful) {
      return ServiceResult.fail(message: requestResult.errorMessage!);
    }

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      final tokens = AuthModel.loadFromResponse(response);
      await tokenService.saveTokensInStorage(tokens);
    }

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Welcome back!",
      HttpStatus.badRequest: "Invalid user data!",
      HttpStatus.unauthorized: "Sign in or password is invalid!",
    });
  }

  void signOut(BuildContext context) {
    tokenService.removeTokensFromStorage().then(
      (_) {
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/welcome", (_) => false);
        }
      },
    );
  }

  Future<ServiceResult> getCurrUser() async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: "current",
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getCurrUser(),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
        data: UserProfileModel.loadFromResponse(response),
      );
    }

    return ServiceResult.fail(message: defaultErrorMessage);
  }

  Future<ServiceResult> getUserById(String userId) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: userId,
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getUserById(userId),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
        data: UserProfileModel.loadFromResponse(response),
      );
    }

    return getServiceResult(statusCode, {
      HttpStatus.badRequest: "This user could not be found!",
      HttpStatus.notFound: "This user could not be found!",
    });
  }

  Future<ServiceResult> getCurrUserCustomExercisePreviews() async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: "current/custom-exercises",
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getCurrUserCustomExercisePreviews(),
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

  Future<ServiceResult> updateCurrUser(UserUpdateModel userUpdate) async {
    final requestResult = await sendRequest(
      method: HttpMethods.put,
      subEndpoint: "current",
      headers: await getHeaders(),
      body: userUpdate.toJson(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => updateCurrUser(userUpdate),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final statusCode = requestResult.response!.statusCode;

    return getServiceResult(statusCode, {
      HttpStatus.ok: "Successfully updated!",
      HttpStatus.badRequest: "Invalid user data!",
    });
  }

  Future<ServiceResult> deleteCurrUser(String password) async {
    final requestResult = await sendRequest(
      method: HttpMethods.delete,
      subEndpoint: "current",
      headers: await getHeaders(),
      body: jsonEncode({"password": password}),
    );

    if (!requestResult.isSuccessful) {
      return ServiceResult.fail(message: requestResult.errorMessage!);
    }

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.unauthorized &&
        response.body == "Incorrect password!") {
      return ServiceResult.fail(message: response.body);
    }

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => deleteCurrUser(password),
      shouldUpdateRefreshToken: false,
    );

    if (baseServiceResult != null) return baseServiceResult;

    if (statusCode == HttpStatus.ok) {
      return ServiceResult.success(
        message: "Your account is deleted successfully!",
        shouldSignOutUser: true,
        popUpColor: Colors.amber.shade800,
      );
    }

    return getServiceResult(statusCode, {
      HttpStatus.badRequest: "Invalid password format!",
      HttpStatus.forbidden: "As a root admin you cannot delete your account!",
    });
  }
}
