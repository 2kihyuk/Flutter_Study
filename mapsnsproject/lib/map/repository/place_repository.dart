import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/address_data.dart';
import '../data/map_data.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

// 검색창에 입력된 텍스트를 통해 api요청 후 리스트(결과)를 받아오는 프로바이더. Future로.
final placesProvider = FutureProvider<List<Place>?>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$mapKey&language=ko',
  );

  try {
    // GET 요청 보내기
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 요청 성공, 응답 처리
      final data = json.decode(response.body);
      print("응답 데이터: $data"); // 응답 데이터 확인
      final placeResponse = PlaceResponse.fromJson(data);
      return placeResponse.results; // 검색된 장소 리스트 반환
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
});


