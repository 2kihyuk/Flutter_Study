import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../common/const/data.dart';
import 'budget_model.dart';

class BudgetNotifier extends StateNotifier<BudgetModel>{
  BudgetNotifier() : super(BudgetModel(month_budget: 0.0, daily_budget: 0.0,daily_budget_copy: 0.0, ));

  // Future<void> getDailyBudgetAnytime(String token) async{
  //
  //   final dio = Dio();
  //
  //   try {
  //     print("Requesting daily-adjusted-budget with token: $token");
  //     final response = await dio.get(
  //       'http://$ip/transactions/daily-adjusted-budget?date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //           "Content-Type": "application/json"
  //         },
  //       ),
  //     );
  //     if (response.statusCode == 200) {
  //       print("BudgetNotifier : getDailyBudgetAnyTime : ${response.data}");
  //       final dailyAdjustedBudget = response.data;
  //
  //       state = BudgetModel(
  //         month_budget: state.month_budget, // 기존 month_budget 유지
  //         daily_budget: dailyAdjustedBudget != null ? dailyAdjustedBudget.toDouble() : 0.0, // daily_adjusted_budget 값으로 업데이트
  //         daily_budget_copy: state.daily_budget_copy, // 기존 daily_budget_copy 유지
  //
  //       );
  //       print("State : ${state.daily_budget}");
  //     } else {
  //       print('BudgetNotifier - getDailyBudgetAnyTime - API 요청 실패: ${response.statusCode}');
  //       print('BudgetNotifier - getDailyBudgetAnyTime - 실패 응답 데이터: ${response.data}');
  //     }
  //   } catch (e) {
  //     print('에러 발생: BudgetNotifier - getDailyBudgetAnytime $e');
  //   }
  // }


  Future<void> getLoadData(String token) async {
    // 확인: 이 함수가 이미 호출되었는지
    final hasLoaded = await storage.read(key: 'hasLoaded');

    if (hasLoaded == 'true') return;  // 이미 실행되었으면 실행하지 않음

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

        // 실행된 후 'hasLoaded' 값 저장
        await storage.write(key: 'hasLoaded', value: 'true');
      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: BudgetNotifier - getLoadData -  $e');
    }
  }

  // Update daily budget
  // void updateDailyBudget(double amount, bool isIncome) {
  //   if (isIncome) {
  //     state = BudgetModel(
  //       month_budget: state.month_budget,
  //       // daily_budget: state.daily_budget + amount,
  //       daily_budget:  state.daily_budget,
  //       daily_budget_copy: state.daily_budget_copy,
  //
  //     );
  //   } else {
  //     state = BudgetModel(
  //       month_budget: state.month_budget,
  //       daily_budget: state.daily_budget ,
  //       // daily_budget: state.daily_budget - amount,
  //       daily_budget_copy: state.daily_budget_copy,
  //
  //     );
  //   }
  // }
}

final budgetProvider  = StateNotifierProvider<BudgetNotifier,BudgetModel>(
      (ref) => BudgetNotifier(),
);