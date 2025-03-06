import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/const/transaction.dart';
import 'budget_model.dart';
import 'budget_notifier.dart';

class DailySummaryNotifier extends StateNotifier<DailySummary> {
  DailySummaryNotifier() : super(DailySummary(
    transactions: [],
    dailyExpenseTotal: 0.0,
    dailyIncomeTotal: 0.0,
    dailyBudgetNoChange: 0.0,
    currentDailyBudget: 0.0,
  ));

  // 상태 업데이트하는 메서드
  void updateDailySummary(DailySummary dailySummary) {
    state = dailySummary;
  }

  // 트랜잭션 데이터를 받아서 summary를 업데이트
  void updateSummaryFromJson(Map<String, dynamic> json) {
    final dailySummary = DailySummary.fromJson(json);
    updateDailySummary(dailySummary);
  }
}
final dailySummaryProvider = StateNotifierProvider<DailySummaryNotifier, DailySummary>(
      (ref) => DailySummaryNotifier(),
);