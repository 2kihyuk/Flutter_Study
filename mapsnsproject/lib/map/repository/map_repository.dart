import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mapsnsproject/map/data/address_data.dart';
import 'package:mapsnsproject/map/data/sns_post_data.dart';


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
      final response = await _http.post(
        Uri.parse('https://api경로'),
        body: model.toJson,
        headers: {'Content-Type': 'application/json'},
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
