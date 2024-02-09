import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/utils/common/popup_info.dart';
import 'package:gym_app_client/utils/common/refresh_error.dart';

class BaseService {
  final TokenService tokenService = TokenService();
  final String _dbAPIBaseUrl = GlobalConfiguration().getValue("dbAPIBaseURL");
  late final String _baseEndpoint;

  BaseService({
    required String baseEndpoint,
  }) {
    _baseEndpoint = baseEndpoint;
  }

  Future<RefreshError?> refreshAccessToken() async {
    try {
      final response = await get(
        Uri.parse("$_dbAPIBaseUrl/users/refresh"),
        headers: await getHeaders(hasAccessToken: false),
      );

      final statusCode = response.statusCode;

      if (statusCode == HttpStatus.ok) {
        await tokenService.saveAccessTokenInStorage(response.body);
        return null;
      } else if (statusCode == HttpStatus.unauthorized) {
        await tokenService.removeTokensFromStorage();

        return RefreshError(
          popUpInfo: fail("You have to sign in your account again!"),
          shouldSignOutUser: true,
        );
      }

      throw Exception();
    } on SocketException {
      return RefreshError(
          popUpInfo: fail(
              "Network error! Please check your internet connection and try again!"));
    } on Exception {
      return RefreshError(
          popUpInfo: fail("Something went wrong! Try again later!"));
    }
  }

  Uri getUri({String? subEndpoint}) {
    final uri = subEndpoint != null
        ? "$_dbAPIBaseUrl/$_baseEndpoint/$subEndpoint"
        : "$_dbAPIBaseUrl/$_baseEndpoint";

    return Uri.parse(uri);
  }

  Future<Map<String, String>> getHeaders(
      {bool hasAccessToken = true, bool hasRefreshToken = true}) async {
    Map<String, String> headers = {"content-type": "application/json"};

    if (hasAccessToken) {
      var accessToken = await tokenService.getAccessTokenFromStorage() ?? "";
      headers["authorization"] = "Bearer $accessToken";
    }

    if (hasRefreshToken) {
      var refreshToken = await tokenService.getRefreshTokenFromStorage() ?? "";
      headers["x-refresh-token"] = refreshToken;
    }

    return headers;
  }

  PopUpInfo success(String message) =>
      PopUpInfo(message: message, color: Colors.green.shade300);

  PopUpInfo fail(String message) =>
      PopUpInfo(message: message, color: Colors.red.shade400);
}
