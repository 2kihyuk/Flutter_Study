import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mapsnsproject/user/data/user_token.dart';

import '../model/address_data.dart';
import '../model/sns_post_data.dart';

final pickPlaceProvider = StateProvider<Place>((ref) {
  return Place(
    formatted_address: '',
    geometry: Geometry(location: Location(lat: 0.0, lng: 0.0)),
    name: '',
    rating: 0.0,
    user_ratings_total: 0,
  );
});

abstract class MapRepository {
  Future<void> createPost(SnsPostModel model);
}

class MapRepositoryImpl implements MapRepository {
  final http.Client _http;

  MapRepositoryImpl(this._http);

  @override
  Future<void> createPost(SnsPostModel model) async {
    try {
      final storage = FlutterSecureStorage();
      final Access_KEY = await storage.read(key: ACCESS_TOKEN_KEY);
      final response = await _http.post(
        Uri.parse('http://43.201.222.85:8080/api/markers'),
        body: jsonEncode(model.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $Access_KEY',
        },
      );
      if (response.statusCode != 200) {
        print(
          'map_repository - creaPost() - statusCode != 200  statusCode is ${response.statusCode}',
        );
        throw Exception('Failed to create post');
      }
    } catch (e) {
      print('map_repository - creaPost() - catchError ${e} ');
    }
  }
}

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl(http.Client());
});
