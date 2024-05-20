import 'dart:io';
import 'package:http/http.dart';
import 'dart:async';
import 'package:global_configuration/global_configuration.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/utils/common/enums/http_methods.dart';
import 'package:gym_app_client/utils/common/request_result.dart';
import 'package:gym_app_client/utils/common/service_result.dart';

class BaseHttpService {
  final tokenService = TokenService();
  final String dbAPIBaseUrl = GlobalConfiguration().getValue("dbAPIBaseURL");
  late final Uri _refreshUrl;
  final String baseEndpoint;
  final connectionTimeout = const Duration(seconds: 4);

  BaseHttpService({
    required this.baseEndpoint,
  }) {
    _refreshUrl = Uri.parse("$dbAPIBaseUrl/users/refresh");
  }

  Uri getUri({String? subEndpoint}) {
    final uri = subEndpoint != null
        ? "$dbAPIBaseUrl/$baseEndpoint/$subEndpoint"
        : "$dbAPIBaseUrl/$baseEndpoint";

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

  Map<String, String> _extractNormalFields(Map<String, dynamic> original) {
    final normalFields = <String, String>{};
    final keysToRemove = <String>[];

    original.forEach((key, value) {
      if (value is String) {
        normalFields[key] = value;
        keysToRemove.add(key);
      }
    });

    keysToRemove.forEach(original.remove);
    return normalFields;
  }

  Future<void> _addAllFieldsToFormDataRequest(
      MultipartRequest request, Map<String, dynamic> body) async {
    Map<String, String> normalFields = _extractNormalFields(body);

    request.fields.addAll(normalFields);

    List<MultipartFile> files = [];

    for (var entry in body.entries) {
      String key = entry.key;
      var value = entry.value;

      if (value is List<String>) {
        for (int i = 0; i < value.length; i++) {
          request.fields['$key[$i]'] = value[i];
        }
      } else if (value is List<File>?) {
        for (int i = 0; i < (value?.length ?? -1); i++) {
          final multipartFile =
              await MultipartFile.fromPath(key, value![i].path);

          files.add(multipartFile);
        }
      }
    }

    request.files.addAll(files);
  }

  Future<Response> _sendFormDataRequest(String method, Uri url,
      Map<String, String> headers, Map<String, dynamic> body) async {
    final request = MultipartRequest(method, url);
    request.headers.addAll(headers);

    await _addAllFieldsToFormDataRequest(request, body);

    StreamedResponse streamedResponse = await request.send();

    return await Response.fromStream(streamedResponse);
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
          response =
              await get(url, headers: headers).timeout(connectionTimeout);
          break;
        case HttpMethods.post:
          if (body is Map<String, dynamic>) {
            response = await _sendFormDataRequest("POST", url, headers, body);
          } else {
            response = await post(url, headers: headers, body: body)
                .timeout(connectionTimeout);
          }

          break;
        case HttpMethods.put:
          if (body is Map<String, dynamic>) {
            response = await _sendFormDataRequest("PUT", url, headers, body);
          } else {
            response = await put(url, headers: headers, body: body)
                .timeout(connectionTimeout);
          }

          break;
        case HttpMethods.delete:
          if (body is Map<String, dynamic>) {
            response = await _sendFormDataRequest("DELETE", url, headers, body);
          } else {
            response = await delete(url, headers: headers, body: body)
                .timeout(connectionTimeout);
          }

          break;
      }

      return RequestResult.success(response: response);
    } catch (e) {
      var errorMessage = "Something went wrong! Try again later!";

      if (e is SocketException || e is TimeoutException) {
        errorMessage =
            "Unable to connect with the server! Check your internet connection and try again!";
      }

      return RequestResult.fail(errorMessage: errorMessage);
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

  ServiceResult getServiceResult(int statusCode, String message,
      {String badRequestMessage = "Invalid data provided!"}) {
    if (statusCode == HttpStatus.ok || statusCode == HttpStatus.noContent) {
      return ServiceResult.success(message: message);
    } else if (statusCode == HttpStatus.badRequest) {
      return ServiceResult.fail(message: badRequestMessage);
    }

    return ServiceResult.fail(message: message);
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

    return ServiceResult.fail(message: response.body);
  }
}
