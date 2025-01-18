import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_project/common/const/data.dart';
import 'package:ready_project/common/const/transaction.dart';

// transactionsProvider는 별도로 선언
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final dio = Dio();
  final token = await FlutterSecureStorage().read(key: JWT_TOKEN); // JWT 토큰을 불러옵니다.

  final response = await dio.get(
    'http://$ip/transactions?date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );
  print("Response status: ${response.statusCode}"); // 응답 상태 코드 확인
  print("Response data: ${response.data}"); // 응답 데이터 확인

  if (response.statusCode == 200) {
    List<dynamic> data = response.data;
    return data.map((json) => Transaction.fromJson(json)).toList(); // JSON을 Transaction 리스트로 변환
  } else {
    throw Exception('Failed to load transactions');
  }
});
