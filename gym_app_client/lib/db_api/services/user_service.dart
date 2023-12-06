import 'package:gym_app_client/db_api/models/user/user_signup_model.dart';
import 'package:gym_app_client/db_api/services/base_service.dart';
import 'package:http/http.dart';

class UserService extends BaseService {
  UserService()
      : super(baseEndpoint: "users", subEndpoints: ["signup", "signin"]);

  Future<String> signUpNewUser(UserSignUpModel user) async {
    try {
      final response = await post(
        urls[0],
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
