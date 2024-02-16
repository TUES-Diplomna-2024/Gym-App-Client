import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:gym_app_client/db_api/models/auth_model.dart';

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAccessTokenInStorage(String accessToken) async {
    await _storage.write(key: "accessToken", value: accessToken);
  }

  Future<String?> getAccessTokenFromStorage() async {
    return await _storage.read(key: "accessToken");
  }

  Future<Map<String, dynamic>?> getAccessTokenPayload() async {
    String? accessToken = await getAccessTokenFromStorage();

    if (accessToken == null || accessToken.isEmpty) return null;

    return JwtDecoder.tryDecode(accessToken);
  }

  Future<String?> getCurrUserRole() async {
    final payload = await getAccessTokenPayload();
    return payload?["userRole"];
  }

  Future<String?> getCurrUserId() async {
    final payload = await getAccessTokenPayload();
    return payload?["userId"];
  }

  Future<void> saveRefreshTokenInStorage(String refreshToken) async {
    await _storage.write(key: "refreshToken", value: refreshToken);
  }

  Future<String?> getRefreshTokenFromStorage() async {
    return await _storage.read(key: "refreshToken");
  }

  Future<void> saveTokensInStorage(AuthModel authModel) async {
    await saveAccessTokenInStorage(authModel.accessToken);
    await saveRefreshTokenInStorage(authModel.refreshToken);
  }

  Future<void> removeTokensFromStorage() async {
    await _storage.delete(key: "accessToken");
    await _storage.delete(key: "refreshToken");
  }
}
