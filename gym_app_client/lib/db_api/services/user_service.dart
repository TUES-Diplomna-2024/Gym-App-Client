import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_preview_model.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_extended_model.dart';
import 'package:gym_app_client/db_api/services/base_http_service.dart';
import 'package:gym_app_client/utils/common/enums/assignable_role.dart';
import 'package:gym_app_client/utils/common/enums/http_methods.dart';
import 'package:gym_app_client/utils/common/service_result.dart';
import 'package:gym_app_client/db_api/models/auth_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';
import 'package:gym_app_client/db_api/models/user/user_signin_model.dart';
import 'package:gym_app_client/db_api/models/user/user_profile_model.dart';
import 'package:gym_app_client/db_api/models/user/user_update_model.dart';

class UserService extends BaseHttpService {
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

      return getServiceResult(
          statusCode, "Your account has been successfully created!");
    }

    return getServiceResult(statusCode, response.body);
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

      return getServiceResult(statusCode, "Welcome back!");
    }

    return getServiceResult(statusCode, response.body);
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

    return ServiceResult.success(
      data: UserProfileModel.loadFromResponse(response),
    );
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
    return getServiceResult(statusCode, "Successfully updated!");
  }

  Future<ServiceResult> deleteCurrUser(String password) async {
    final requestResult = await sendRequest(
      method: HttpMethods.delete,
      subEndpoint: "current",
      headers: await getHeaders(includeContentType: false),
      body: {"password": password},
    );

    if (!requestResult.isSuccessful) {
      return ServiceResult.fail(message: requestResult.errorMessage!);
    }

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => deleteCurrUser(password),
      shouldUpdateRefreshToken: false,
    );

    if (baseServiceResult != null) return baseServiceResult;

    if (statusCode == HttpStatus.noContent) {
      return ServiceResult.success(
        message: "Your account has been successfully deleted!",
        shouldSignOutUser: true,
        popUpColor: Colors.amber.shade800,
      );
    }

    return getServiceResult(statusCode, response.body);
  }

  Future<ServiceResult> getUserSearchResults(String query) async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      subEndpoint: "search?query=$query",
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => getUserSearchResults(query),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      final userPreviews =
          UserPreviewModel.getUserPreviewsFromResponse(response);

      return ServiceResult.success(data: userPreviews);
    }

    return getServiceResult(statusCode, response.body);
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
        data: UserProfileExtendedModel.loadFromResponse(response),
      );
    }

    return getServiceResult(statusCode, response.body,
        badRequestMessage: "The specified user could not be found!");
  }

  Future<ServiceResult> deleteUserById(String userId) async {
    final requestResult = await sendRequest(
      method: HttpMethods.delete,
      subEndpoint: userId,
      headers: await getHeaders(),
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => deleteUserById(userId),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "Account has been successfully deleted!");
    }

    return getServiceResult(statusCode, response.body,
        badRequestMessage: "The specified user could not be found!");
  }

  Future<ServiceResult> assignUserRole(
      String userId, AssignableRole role) async {
    final requestResult = await sendRequest(
      method: HttpMethods.put,
      subEndpoint: "$userId/role",
      headers: await getHeaders(includeContentType: false),
      body: {"role": role.name},
    );

    final baseServiceResult = await baseAuthResponseHandle(
      requestResult: requestResult,
      currMethod: () => assignUserRole(userId, role),
    );

    if (baseServiceResult != null) return baseServiceResult;

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.noContent) {
      return getServiceResult(
          statusCode, "Role has been successfully assigned!");
    }

    return getServiceResult(statusCode, response.body);
  }
}
