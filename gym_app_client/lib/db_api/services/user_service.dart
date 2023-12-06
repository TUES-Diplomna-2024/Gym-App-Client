import 'package:global_configuration/global_configuration.dart';
import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';
import 'package:http/http.dart';

class UserService {
  late final String _dbAPIBaseUrl;
  late final List<Uri> _urls;

  UserService() {
    _dbAPIBaseUrl = GlobalConfiguration().getValue("dbAPIBaseURL");
    _urls = [
      "signup",
      "signin",
    ].map((String ep) => Uri.parse("$_dbAPIBaseUrl/users/$ep")).toList();
  }

  Future<String> signUpNewUser(UserSignUpModel user) async {
    try {
      final response = await post(
        _urls[0],
        headers: {"Content-Type": "application/json"},
        body: user.toJson(),
      );

      switch (response.statusCode) {
        case 200:
          return "200 Ok";
        case 400:
          return "400 Bad Request";
        case 409:
          return "409 Conflict";
        default:
          return "Unhandeled status code: ${response.statusCode}";
      }
    } catch (er) {
      return "CATCH EXCEPTION: ${er.toString()}";
    }
  }
}
