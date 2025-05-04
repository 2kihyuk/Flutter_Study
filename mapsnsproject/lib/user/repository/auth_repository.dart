import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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
  return repo.login(userId: loginReq.userId, password: loginReq.password);
});

class AuthRepository {
  static const _baseUrl = 'https://your.api.host'; // 실제 도메인으로 교체

  Future<LoginResponse> login({
    required String userId,

    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/auth/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        LoginRequest(userId: userId, password: password).toJson(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(body);
    } else {
      // 에러 메시지가 body.message 필드에 올 수도 있으니 안전하게 파싱
      String err;
      try {
        err =
            (jsonDecode(response.body)['message'] as String?) ?? '로그인에 실패했습니다.';
      } catch (_) {
        err = '로그인 중 알 수 없는 오류가 발생했습니다.';
      }
      throw Exception(err);
    }
  }
}
