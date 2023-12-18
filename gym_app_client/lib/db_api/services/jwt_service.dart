import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveJwtInStorage(String jwt) async {
    if (!isJwtValid(jwt)) throw const FormatException("Invalid JWT!");

    await _storage.write(key: "jwt", value: jwt);
  }

  Future<void> deleteJwtFromStorage() async =>
      await _storage.delete(key: "jwt");

  Future<String?> getJwtFromStorage() async => await _storage.read(key: "jwt");

  Future<Map<String, dynamic>?> getJwtPayload() async {
    String? token = await getJwtFromStorage();

    if (token == null) return null;

    return JwtDecoder.decode(token);
  }

  Future<bool> isJwtExpired() async {
    String? jwt = await getJwtFromStorage();

    if (jwt == null) return true;

    return JwtDecoder.isExpired(jwt);
  }

  bool isJwtValid(String jwt) => JwtDecoder.tryDecode(jwt) != null;
}
