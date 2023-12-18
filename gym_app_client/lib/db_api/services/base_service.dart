import 'package:global_configuration/global_configuration.dart';

class BaseService {
  final String _dbAPIBaseUrl = GlobalConfiguration().getValue("dbAPIBaseURL");
  late final String _baseEndpoint;

  BaseService({
    required String baseEndpoint,
  }) {
    _baseEndpoint = baseEndpoint;
  }

  Uri getUri(String subEndpoint) =>
      Uri.parse("$_dbAPIBaseUrl/$_baseEndpoint/$subEndpoint");
}
