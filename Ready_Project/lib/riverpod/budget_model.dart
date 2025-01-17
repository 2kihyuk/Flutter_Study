
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BudgetModel{

 double month_budget;
 double daily_budget;

BudgetModel({
  required this.month_budget,
  required this.daily_budget,
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

