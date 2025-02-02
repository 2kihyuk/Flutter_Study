// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// @JsonSerializable()
// class BudgetModel {
//   double month_budget; //한달 총 예산
//   double daily_budget; //하루 총 예산
//   final double daily_budget_copy; //하루 총 예산 복사값 - 변동없음
//
//   //변동이 없을때는 초기값을 띄워놓고 지출마감하기 버튼누르면
//
//   BudgetModel({
//     required this.month_budget,
//     required this.daily_budget,
//     required this.daily_budget_copy,
//   });
//
//   factory BudgetModel.fromJson(Map<String, dynamic> json) {
//     return BudgetModel(
//       month_budget: json['monthBudget'] != null
//           ? (json['monthBudget'] as num).toDouble()
//           : 0.0,
//       daily_budget: json['dailyBudget'] != null
//           ? (json['dailyBudget'] as num).toDouble()
//           : 0.0,
//       daily_budget_copy: json['dailyBudget'] != null
//           ? (json['dailyBudget'] as num).toDouble()
//           : 0.0, // daily_budget을 복사해서 초기화
//
//
//     );
//   }
//
//   // toJson 메서드
//   Map<String, dynamic> toJson() {
//     return {
//       'monthBudget': month_budget,
//       'dailyBudget': daily_budget,
//     };
//   }
// }
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BudgetModel {
  double month_budget; // 한 달 총 예산
  double daily_budget; // 하루 총 예산
  final double daily_budget_copy; // 하루 총 예산 복사값 - 변동없음

  // BudgetModel({
  //   required this.month_budget,
  //   required this.daily_budget,
  //   required this.daily_budget_copy,
  // });
  //
  // factory BudgetModel.fromJson(Map<String, dynamic> json) {
  //   return BudgetModel(
  //     month_budget: json['monthBudget'] != null
  //         ? (json['monthBudget'] as num).toDouble()
  //         : 0.0,
  //     daily_budget: json['dailyBudget'] != null
  //         ? (json['dailyBudget'] as num).toDouble()
  //         : 0.0,
  //     daily_budget_copy: json['dailyBudget'] != null
  //         ? (json['dailyBudget'] as num).toDouble()
  //         : 0.0, // daily_budget을 복사해서 초기화
  //   );
  // }
  // 생성자에서 daily_budget_copy는 daily_budget 값을 복사하여 초기화
  BudgetModel({
    required this.month_budget,
    required this.daily_budget,
  }) : daily_budget_copy = daily_budget; // daily_budget의 값을 복사해서 초기화

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

  Map<String, dynamic> toJson() {
    return {
      'monthBudget': month_budget,
      'dailyBudget': daily_budget,
    };
  }
}
