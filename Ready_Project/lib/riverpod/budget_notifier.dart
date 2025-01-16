import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'budget_model.dart';

class BudgetNotifier extends StateNotifier<BudgetModel>{
  BudgetNotifier() : super(BudgetModel(month_budget: 0.0, daily_budget: 0.0));


  Future<void> getLoadData(String token) async{

    final dio = Dio();

    // final token = await storage.read(key: JWT_TOKEN);

    try {
      final response = await dio.get(
        'http://your_api_url/user-info',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        state = BudgetModel.fromJson(response.data); // 상태 업데이트
      } else {
        print('API 요청 실패');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }
}

final budgetProvider  = StateNotifierProvider<BudgetNotifier,BudgetModel>(
    (ref) => BudgetNotifier(),
);

//
// setState(() {
// month_budget = resp.data['monthBudget'] ?? 0.0;  // null이거나 없을 경우 0.0 설정
// daily_budget = resp.data['dailyBudget'] ?? 0.0;  // null이거나 없을 경우 0.0 설정
// birthDate = resp.data['birthDate'] ?? '생일';
// name = resp.data['name'] ?? '이름';
// });