import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mapsnsproject/user/data/user_token.dart';

import '../data/login_request.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// 2) 로그인 호출을 위한 FutureProvider.family
final loginProvider = FutureProvider.family<LoginResponse, LoginRequest>((
  ref,
  loginReq,
) async {
  final repo = ref.read(authRepositoryProvider);
  return repo.login(loginId: loginReq.loginId, password: loginReq.password);
});

class AuthRepository {
  static const _baseUrl = 'http://43.201.222.85:8080'; // 실제 도메인으로 교체

  Future<LoginResponse> login({
    required String loginId,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/auth/login');
    final body ={
      'loginId': loginId,
      'password': password,
    };
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body)
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      print(response.statusCode);
      print(response.body);
      final storage = FlutterSecureStorage();
      // 1) 토큰을 secure storage에 저장
      await storage.write(
        key: ACCESS_TOKEN_KEY,
        value: body['accessToken'] as String,
      );
      await storage.write(
        key: REFRESH_TOKEN_KEY,
        value: body['refreshToken'] as String,
      );
      return LoginResponse.fromJson(body);
    } else {
      print(response.statusCode);
      // 에러 메시지가 body.message 필드에 올 수도 있으니 안전하게 파싱
      String err;
      try {
        err =
            (jsonDecode(response.body)['message'] as String?) ?? '로그인에 실패했습니다.';
      } catch (_) {
        print(response.statusCode);
        err = '로그인 중 알 수 없는 오류가 발생했습니다.';
      }
      throw Exception(err);
    }
  }
}


// jsonEncode(
// LoginRequest(loginId: loginId, password: password).toJson(),
// ),