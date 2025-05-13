import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../user/data/user_token.dart';
import '../model/sns_post_data.dart';

const _baseUrl = 'http://43.201.222.85:8080';

/// 1) Repository 인터페이스
abstract class MarkerRepository {
  Future<List<SnsPostModel>> fetchAll();

  Future<SnsPostModel> fetchById(int markerId);
}

/// 2) 구현체
class MarkerRepositoryImpl implements MarkerRepository {
  final http.Client _client;
  final FlutterSecureStorage _storage;

  MarkerRepositoryImpl(this._client, this._storage);

  @override
  Future<List<SnsPostModel>> fetchAll() async {
    final token = await _storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await _client.get(
      Uri.parse('$_baseUrl/api/markers'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final List<dynamic> list = jsonDecode(resp.body);
      return list
          .map((e) => SnsPostModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('markers fetch failed: ${resp.statusCode}');
    }
  }

  @override
  Future<SnsPostModel> fetchById(int markerId) async {
    final token = await _storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await _client.get(
      (Uri.parse('$_baseUrl/api/markers/markerId')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if(resp.statusCode == 200){
      final Map<String, dynamic> json = jsonDecode(resp.body);
      return SnsPostModel.fromJson(json);
    }else {
      throw Exception('Failed to load marker $markerId');
    }
  }
}

/// 3) Riverpod Provider
final markerRepositoryProvider = Provider<MarkerRepository>(
  (ref) => MarkerRepositoryImpl(http.Client(), const FlutterSecureStorage()),
);

/// 4) FutureProvider 로 감싸기
final markersProvider = FutureProvider<List<SnsPostModel>>((ref) {
  final repo = ref.read(markerRepositoryProvider);
  return repo.fetchAll();
});

/// 5)markerId를 통해서 특정 게시물에 대한 데이터 불러오기
///
    final postByIdProvider = FutureProvider.family<SnsPostModel,int>((ref,markerId){
      final repo = ref.read(markerRepositoryProvider);
      return repo.fetchById(markerId);
    });
