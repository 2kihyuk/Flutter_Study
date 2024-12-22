import 'package:flutter/material.dart';

class BudgetModel extends ChangeNotifier {
  String _budget = '0'; // 예산 초기 값
  double _dailyBudget = 0; // 하루 예산

  String get budget => _budget;

  double get dailyBudget => _dailyBudget;

  set budget(String value) {
    _budget = value;
    _calculateDailyBudget(); // 예산 값이 변경되면 하루 예산을 재계산
    notifyListeners(); // 상태가 변경되었음을 알립니다.
  }

  // 하루 예산을 계산하는 함수
  void _calculateDailyBudget() {
    double monthlyBudget = double.tryParse(_budget.replaceAll(',', '')) ?? 0;
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    int daysInMonth = lastDayOfMonth.day;

    _dailyBudget = monthlyBudget / daysInMonth; // 하루 예산 계산
  }

  set dailyBudget(double value) {
    _dailyBudget = value;
    notifyListeners();
  }
}
