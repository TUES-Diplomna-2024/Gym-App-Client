class JwtModel {
  late final String jwt;

  JwtModel({
    required this.jwt,
  });

  JwtModel.loadFromMap(Map<String, dynamic> data) {
    jwt = data["jwt"] as String;
  }
}
