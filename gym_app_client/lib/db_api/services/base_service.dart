import 'package:global_configuration/global_configuration.dart';

class BaseService {
  late final String _dbAPIBaseUrl;
  late final String _baseEndpoint;
  late final List<Uri> _urls;

  BaseService({
    required String baseEndpoint,
    required List<String> subEndpoints,
  }) {
    _dbAPIBaseUrl = GlobalConfiguration().getValue("dbAPIBaseURL");
    _baseEndpoint = baseEndpoint;
    _urls = subEndpoints
        .map((String sep) => Uri.parse("$_dbAPIBaseUrl/$_baseEndpoint/$sep"))
        .toList();
  }

  List<Uri> get urls => _urls;
}
