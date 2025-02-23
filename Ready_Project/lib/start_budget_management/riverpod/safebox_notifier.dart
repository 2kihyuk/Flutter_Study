import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';

class SafeBoxNotifier extends StateNotifier<double> {
  SafeBoxNotifier() : super(0.0);

  Future<void> fetchSafeBoxData() async {
    final dio = Dio();
    final token = await storage.read(key: JWT_TOKEN);

    try {
      final response = await dio.get(
        'http://$ip/user-info',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        double fetchedSafeBox = response.data['safeBox'] ?? 0.0;
        state = fetchedSafeBox; // 상태 업데이트
      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: SafeBox - getSafeBoxData -  $e');
    }
  }
}

final safeBoxProvider = StateNotifierProvider<SafeBoxNotifier, double>(
  (ref) => SafeBoxNotifier(),
);
