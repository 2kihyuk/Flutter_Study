import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BudgetModel {
  double month_budget; //한달 총 예산
  double daily_budget; //하루 총 예산
   final double daily_budget_copy; //하루 총 예산 복사값 - 변동없음
  double daily_expense_total; // 하루 총 지출금액 총합
  double daily_income_total; // 하루 총 수입금액 총합

  BudgetModel({
    required this.month_budget,
    required this.daily_budget,
    required this.daily_budget_copy,
    this.daily_expense_total = 0.0,
    this.daily_income_total = 0.0,
  });


  // fromJson 메서드에서 null 처리 추가
  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      month_budget: json['monthBudget'] != null
          ? (json['monthBudget'] as num).toDouble()
          : 0.0,
      daily_budget: json['dailyBudget'] != null
          ? (json['dailyBudget'] as num).toDouble()
          : 0.0,
      daily_budget_copy: json['dailyBudget'] != null
          ? (json['dailyBudget'] as num).toDouble()
          : 0.0, // daily_budget을 복사해서 초기화

    );
  }

  // toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'monthBudget': month_budget,
      'dailyBudget': daily_budget,
    };
  }
}
