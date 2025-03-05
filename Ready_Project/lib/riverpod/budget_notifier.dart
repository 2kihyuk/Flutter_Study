import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../common/const/data.dart';
import 'budget_model.dart';

class BudgetNotifier extends StateNotifier<BudgetModel>{
  BudgetNotifier() : super(BudgetModel(month_budget: 0.0, daily_budget: 0.0));


  Future<void> getLoadData(String token) async {

    final dio = Dio();

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
        print("BudgetNotifier : GetLoadData : ${response.data}");
        state = BudgetModel.fromJson(response.data); // 상태 업데이트

      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: BudgetNotifier - getLoadData -  $e');
    }
  }

}

final budgetProvider  = StateNotifierProvider<BudgetNotifier,BudgetModel>(
      (ref) => BudgetNotifier(),
);