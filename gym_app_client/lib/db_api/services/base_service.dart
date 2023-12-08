import 'package:global_configuration/global_configuration.dart';

class BaseService {
  late final String _dbAPIBaseUrl;
  late final String _baseEndpoint;

  BaseService({
    required String baseEndpoint,
  }) {
    _dbAPIBaseUrl = GlobalConfiguration().getValue("dbAPIBaseURL");
    _baseEndpoint = baseEndpoint;
  }

  Uri getUri(String subEndpoint) =>
      Uri.parse("$_dbAPIBaseUrl/$_baseEndpoint/$subEndpoint");
}
