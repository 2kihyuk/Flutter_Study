import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mapsnsproject/user/data/login_response.dart';
import 'package:mapsnsproject/user/data/user_token.dart';

import '../data/login_request.dart';


class AuthRepository {

  final storage = const FlutterSecureStorage();


  ///로그아웃.. 로그아웃 버튼 어디에 넣을건지?
  Future<void> Logout() async{
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    final uri = Uri.parse('$baseUrl/api/auth/logout');
    await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refreshToken' : refreshToken}),
    );

    await storage.delete(key: ACCESS_TOKEN_KEY);
    await storage.delete(key: REFRESH_TOKEN_KEY);
  }


  Future<bool> tryRefresh() async{
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    if (refreshToken == null) return false;

    final uri = Uri.parse('$baseUrl/api/auth/refresh');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      // 새로 발급된 토큰 저장
      await storage.write(key: ACCESS_TOKEN_KEY,  value: body['accessToken']  as String);
      await storage.write(key: REFRESH_TOKEN_KEY, value: body['refreshToken'] as String);
      return true;
    } else {
      // 리프레시 실패(만료 등) → 로그인 화면으로
      return false;
    }
  }


  Future<LoginResponse> login({
    required String loginId,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
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


// jsonEncode(
// LoginRequest(loginId: loginId, password: password).toJson(),
// ),

// eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaWF0IjoxNzQ2Nzk5NjU0LCJleHAiOjE3NDY4MDA1NTR9.V9KpyaguFhOuppbV5QPVtbuK8jGFb_pUcvs-7Ifxs8c
// eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaWF0IjoxNzQ2Nzk5NjgyLCJleHAiOjE3NDY4MDA1ODJ9.ykle2NSFcp0SnyDeJsXlitNtg0NSZys9Wrtc1kgDY_o