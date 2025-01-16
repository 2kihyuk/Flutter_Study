
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'budget_model.g.dart';
@JsonSerializable()
class BudgetModel{

 double month_budget;
 double daily_budget;

BudgetModel({
  required this.month_budget,
  required this.daily_budget,
});

 factory BudgetModel.fromJson(Map<String, dynamic> json) =>
     _$BudgetModelFromJson(json);

 Map<String, dynamic> toJson() => _$BudgetModelToJson(this);

}

