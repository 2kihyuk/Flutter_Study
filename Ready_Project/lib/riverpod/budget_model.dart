import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BudgetModel {
  double month_budget; //한달 총 예산
  double daily_budget; //하루 총 예산
   final double daily_budget_copy; //하루 총 예산 복사값 - 변동없음


  BudgetModel({
    required this.month_budget,
    required this.daily_budget,
    required this.daily_budget_copy,

  });

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
