import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  static Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  static bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
}
