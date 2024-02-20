import 'dart:io';
import 'package:http/http.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/utils/common/http_methods.dart';
import 'package:gym_app_client/utils/common/request_result.dart';
import 'package:gym_app_client/utils/common/service_result.dart';

class BaseService {
  final tokenService = TokenService();
  final String _dbAPIBaseUrl = GlobalConfiguration().getValue("dbAPIBaseURL");
  late final Uri _refreshUrl;
  final String baseEndpoint;
  final String defaultErrorMessage = "Something went wrong! Try again later!";

  BaseService({
    required this.baseEndpoint,
  }) {
    _refreshUrl = Uri.parse("$_dbAPIBaseUrl/users/refresh");
  }

  Uri getUri({String? subEndpoint}) {
    final uri = subEndpoint != null
        ? "$_dbAPIBaseUrl/$baseEndpoint/$subEndpoint"
        : "$_dbAPIBaseUrl/$baseEndpoint";

    return Uri.parse(Uri.encodeFull(uri));
  }

  Future<Map<String, String>> getHeaders({
    bool hasAccessToken = true,
    bool hasRefreshToken = true,
    bool includeContentType = true,
  }) async {
    Map<String, String> headers = {};

    if (includeContentType) {
      headers["content-type"] = "application/json";
    }

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

  Future<RequestResult> sendRequest({
    required HttpMethods method,
    required Map<String, String> headers,
    String? subEndpoint,
    Uri? fullUrl,
    Object? body,
  }) async {
    try {
      final url = fullUrl ?? getUri(subEndpoint: subEndpoint);
      late final Response response;

      switch (method) {
        case HttpMethods.get:
          response = await get(url, headers: headers);
          break;
        case HttpMethods.post:
          response = await post(url, headers: headers, body: body);
          break;
        case HttpMethods.put:
          response = await put(url, headers: headers, body: body);
          break;
        case HttpMethods.delete:
          response = await delete(url, headers: headers, body: body);
          break;
      }

      return RequestResult.success(response: response);
    } on SocketException {
      return RequestResult.fail(
        errorMessage:
            "Network error! Please check your internet connection and try again!",
      );
    } on Exception {
      return RequestResult.fail(errorMessage: defaultErrorMessage);
    }
  }

  Future<ServiceResult?> baseAuthResponseHandle({
    required RequestResult requestResult,
    required Future<ServiceResult> Function() currMethod,
    bool shouldUpdateRefreshToken = true,
  }) async {
    if (!requestResult.isSuccessful) {
      return ServiceResult.fail(message: requestResult.errorMessage!);
    }

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.unauthorized) {
      final result = await refreshAccessToken();
      if (!result.isSuccessful) return result;
      return await currMethod();
    }

    if (shouldUpdateRefreshToken) {
      await tokenService
          .saveRefreshTokenInStorage(response.headers["x-refresh-token"]!);
    }

    return null;
  }

  Future<ServiceResult> refreshAccessToken() async {
    final requestResult = await sendRequest(
      method: HttpMethods.get,
      fullUrl: _refreshUrl,
      headers: await getHeaders(hasAccessToken: false),
    );

    if (!requestResult.isSuccessful) {
      return ServiceResult.fail(message: requestResult.errorMessage!);
    }

    final response = requestResult.response!;
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      await tokenService.saveAccessTokenInStorage(response.body);
      return ServiceResult.success();
    } else if (statusCode == HttpStatus.unauthorized) {
      return ServiceResult.fail(
        message: "You have to sign in your account again!",
        shouldSignOutUser: true,
      );
    }

    return ServiceResult.fail(message: defaultErrorMessage);
  }
}
