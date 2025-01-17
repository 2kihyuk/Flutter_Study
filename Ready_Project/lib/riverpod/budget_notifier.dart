import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/const/data.dart';
import 'budget_model.dart';

class BudgetNotifier extends StateNotifier<BudgetModel>{
  BudgetNotifier() : super(BudgetModel(month_budget: 0.0, daily_budget: 0.0));


  Future<void> getLoadData(String token) async{

    final dio = Dio();

    // final token = await storage.read(key: JWT_TOKEN);

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
        print(response.data);
        state = BudgetModel.fromJson(response.data); // 상태 업데이트
      } else {
        print('API 요청 실패');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // Update daily budget
  void updateDailyBudget(double amount, bool isIncome) {
    if (isIncome) {
      state = BudgetModel(
        month_budget: state.month_budget,
        daily_budget: state.daily_budget + amount,
      );
    } else {
      state = BudgetModel(
        month_budget: state.month_budget,
        daily_budget: state.daily_budget - amount,
      );
    }
  }
}


final budgetProvider  = StateNotifierProvider<BudgetNotifier,BudgetModel>(
    (ref) => BudgetNotifier(),
);

