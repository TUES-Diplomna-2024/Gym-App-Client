import 'package:http/http.dart';

class RequestResult {
  final bool isSuccessful;
  final Response? response;
  final String? errorMessage;

  RequestResult.success({
    required this.response,
    this.errorMessage,
  })  : assert(response != null && errorMessage == null),
        isSuccessful = true;

  RequestResult.fail({
    required this.errorMessage,
    this.response,
  })  : assert(response == null && errorMessage != null),
        isSuccessful = false;
}
